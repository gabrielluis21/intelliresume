// lib/pages/edit_profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/providers/user_provider.dart';
import '../widgets/layout_template.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _picker = ImagePicker();
  File? _imageFile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile.value != null) {
      _nameController.text = userProfile.value?.name ?? '';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final userProfileRepository = ref.read(userProfileRepositoryProvider);
      final currentProfile = ref.read(userProfileProvider);

      // Atualizar perfil usando o repositório
      final profile = currentProfile.value;
      if (profile == null) {
        throw Exception('Perfil do usuário não encontrado.');
      }
      await userProfileRepository.updateProfile(
        profile.copyWith(
          name: _nameController.text,
          profilePictureUrl:
              _imageFile != null ? _imageFile!.path : profile.profilePictureUrl,
        ),
      );

      // Forçar refresh do provider
      ref.invalidate(userProfileProvider);

      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );

      // Voltar para a página de perfil
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar perfil: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verifyEmail() async {
    setState(() => _loading = true);
    try {
      final userProfileRepository = ref.read(userProfileRepositoryProvider);
      await userProfileRepository.verifyProfileEmail();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email de verificação enviado!'),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao enviar verificação: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final user = userProfile.value;
    final email = user?.email ?? '';
    final phone = user?.phone ?? '';
    final emailVerified = user?.emailVerified ?? false;
    final photoUrl = user?.profilePictureUrl;

    return LayoutTemplate(
      selectedIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 100,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Editar Perfil',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),

                  // Seção de Foto de Perfil
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : (photoUrl != null
                                      ? NetworkImage(photoUrl)
                                      : null),
                          child:
                              photoUrl == null && _imageFile == null
                                  ? const Icon(Icons.person, size: 60)
                                  : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Campo de Nome
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo de Email (read-only)
                  TextFormField(
                    initialValue: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      suffixIcon:
                          emailVerified
                              ? const Tooltip(
                                message: 'Email verificado',
                                child: Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                ),
                              )
                              : null,
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 8),

                  // Botão de verificação de email
                  if (!emailVerified) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.mark_email_unread),
                        label: const Text('Verificar email'),
                        onPressed: _verifyEmail,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Campo de Email (read-only)
                  TextFormField(
                    initialValue: phone ?? '',
                    decoration: InputDecoration(
                      labelText: 'Telfone',
                      prefixIcon: const Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botão de Salvar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon:
                          _loading
                              ? const CircularProgressIndicator.adaptive()
                              : const Icon(Icons.save),
                      label: Text(
                        _loading ? 'Salvando...' : 'Salvar Alterações',
                      ),
                      onPressed: _loading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
