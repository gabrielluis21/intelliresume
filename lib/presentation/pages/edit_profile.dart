import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:intelliresume/services/image_upload_service.dart';
import 'package:intelliresume/core/providers/domain_providers.dart';
import '../../core/providers/user/user_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _disabilityDescriptionController = TextEditingController();
  final _picker = ImagePicker();

  File? _imageFile;
  bool _loading = false;
  bool _isPCD = false;
  late AppLocalizations l10n;
  final List<String> _availableDisabilities = [
    'Física',
    'Auditiva',
    'Visual',
    'Mental',
    'Intelectual',
    'Múltipla',
  ];
  final Set<String> _selectedDisabilities = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
  }

  void _loadUserData() {
    final user = ref.read(userProfileProvider).value;
    if (user != null) {
      _nameController.text = user.name ?? '';
      _phoneController.text = user.phone ?? '';
      _isPCD = user.pcdInfo?.isPCD != null;
      _selectedDisabilities.addAll(user.pcdInfo!.disabilityTypes!);
      _disabilityDescriptionController.text =
          user.pcdInfo?.disabilityDescription ?? '';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final currentProfile = ref.read(userProfileProvider).value;

      if (currentProfile == null) {
        throw Exception(l10n.editProfile_userProfileNotFound);
      }

      String? finalProfilePictureUrl = currentProfile.profilePictureUrl;

      if (_imageFile != null) {
        if (currentProfile.uid == null) {
          throw Exception(l10n.editProfile_uidNotFoundForImageUpload);
        }
        finalProfilePictureUrl = await ImageUploadService()
            .uploadProfilePicture(_imageFile!, currentProfile.uid!);
      }

      final updatedProfile = currentProfile.copyWith(
        name: _nameController.text,
        phone: _phoneController.text,
        profilePictureUrl: finalProfilePictureUrl,
        pcdInfo: PcdInfo(
          isPCD: _isPCD,
          disabilityTypes: _selectedDisabilities.toList(),
          disabilityDescription: _disabilityDescriptionController.text,
        ),
      );

      final saveUseCase = ref.read(saveUserProfileUseCaseProvider);
      await saveUseCase(updatedProfile);
      //ref.read(localResumeProvider.notifier).updatePersonalInfo(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.editProfile_profileUpdatedSuccessfully)),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.editProfile_errorUpdatingProfile(e.toString())),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider).value;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.editProfile_editProfile,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      _buildProfilePictureSection(user.profilePictureUrl),
                      const SizedBox(height: 24),
                      _buildTextField(
                        _nameController,
                        l10n.editProfile_name,
                        Icons.person,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _phoneController,
                        l10n.editProfile_phone,
                        Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildAccessibilitySection(),
                      const SizedBox(height: 32),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildProfilePictureSection(String? photoUrl) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                _imageFile != null
                    ? FileImage(_imageFile!)
                    : (photoUrl != null ? NetworkImage(photoUrl) : null)
                        as ImageProvider?,
            child:
                photoUrl == null && _imageFile == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: _pickImage,
              tooltip: l10n.editProfile_selectProfilePicture,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: keyboardType,
      validator:
          (value) =>
              (value == null || value.isEmpty)
                  ? l10n.editProfile_fieldRequired
                  : null,
    );
  }

  Widget _buildAccessibilitySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.editProfile_accessibilityAndInclusion,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: Text(l10n.editProfile_informPCD),
              subtitle: Text(l10n.editProfile_pcdInfoOptional),
              value: _isPCD,
              onChanged:
                  (bool? value) => setState(() => _isPCD = value ?? false),
            ),
            if (_isPCD)
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.editProfile_disabilityTypes,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children:
                          _availableDisabilities.map((disability) {
                            String localizedDisability;
                            switch (disability) {
                              case 'Física':
                                localizedDisability =
                                    l10n.editProfile_physicalDisability;
                                break;
                              case 'Auditiva':
                                localizedDisability =
                                    l10n.editProfile_auditoryDisability;
                                break;
                              case 'Visual':
                                localizedDisability =
                                    l10n.editProfile_visualDisability;
                                break;
                              case 'Mental':
                                localizedDisability =
                                    l10n.editProfile_mentalDisability;
                                break;
                              case 'Intelectual':
                                localizedDisability =
                                    l10n.editProfile_intellectualDisability;
                                break;
                              case 'Múltipla':
                                localizedDisability =
                                    l10n.editProfile_multipleDisabilities;
                                break;
                              default:
                                localizedDisability = disability;
                            }
                            return FilterChip(
                              label: Text(localizedDisability),
                              selected: _selectedDisabilities.contains(
                                disability,
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedDisabilities.add(disability);
                                  } else {
                                    _selectedDisabilities.remove(disability);
                                  }
                                });
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _disabilityDescriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.editProfile_descriptionOrCIDOptional,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Icon(
            _loading ? null : Icons.save,
            semanticLabel:
                _loading
                    ? l10n.editProfile_saving
                    : l10n.editProfile_saveChanges,
          ),
          ElevatedButton(
            onPressed: _loading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            // Adiciona o indicador de progresso dentro do botão
            child:
                _loading
                    ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                    : Text(
                      _loading
                          ? l10n.editProfile_saving
                          : l10n.editProfile_saveChanges,
                    ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _disabilityDescriptionController.dispose();
    super.dispose();
  }
}