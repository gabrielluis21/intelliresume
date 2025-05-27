import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelliresume/core/providers/resume_template_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/app_localizations.dart';
//import '../widgets/header_section.dart';
import '../widgets/section.dart';
import '../widgets/experience_list.dart';
import '../widgets/education_list.dart';
import '../widgets/skill_chip.dart';
import '../widgets/social_link.dart';
import '../../core/providers/cv_provider.dart';

class ResumeFormContent extends ConsumerStatefulWidget {
  const ResumeFormContent({super.key});

  @override
  ConsumerState<ResumeFormContent> createState() => _ResumeFormContentState();
}

class _ResumeFormContentState extends ConsumerState<ResumeFormContent> {
  final _formKey = GlobalKey<FormState>();

  final ctrlExp = TextEditingController();
  final ctrlEdu = TextEditingController();
  final ctrlSkill = TextEditingController();
  final ctrlUrl = TextEditingController();
  String selectedSocial = 'Escolha';

  final socialItems = ['Escolha', 'GitHub', 'LinkedIn', 'Twitter', 'Website'];

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ref.read(cvDataProvider).about = prefs.getString('about') ?? '';
      ref
          .read(cvDataProvider)
          .experiences
          .addAll(
            List<String>.from(jsonDecode(prefs.getString('exp') ?? '[]')),
          );
      ref
          .read(cvDataProvider)
          .educations
          .addAll(
            List<String>.from(jsonDecode(prefs.getString('edu') ?? '[]')),
          );
      ref
          .read(cvDataProvider)
          .skills
          .addAll(
            List<String>.from(jsonDecode(prefs.getString('skills') ?? '[]')),
          );
      ref
          .read(cvDataProvider)
          .socials
          .addAll(
            List<Map<String, String>>.from(
              jsonDecode(prefs.getString('socials') ?? '[]'),
            ),
          );
    });
  }

  Future<void> _saveData(BuildContext context, CVData data, dynamic t) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('about', data.about);
    await prefs.setString('exp', jsonEncode(data.experiences));
    await prefs.setString('edu', jsonEncode(data.educations));
    await prefs.setString('skills', jsonEncode(data.skills));
    await prefs.setString('socials', jsonEncode(data.socials));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.save)));
  }

  Widget _buildInputSection({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required List<String> list,
    required VoidCallback onAdd,
    required Widget listWidget,
  }) {
    final t = AppLocalizations.of(context);
    return Section(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: t.add),
          ),
          const SizedBox(height: 4),
          ElevatedButton(onPressed: onAdd, child: Text(t.add)),
          const SizedBox(height: 4),
          listWidget,
        ],
      ),
    );
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final t = AppLocalizations.of(context);
    final cvData = ref.watch(cvDataProvider);
    final template = ref.watch(selectedTemplateProvider);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: cvData.about,
              decoration: InputDecoration(labelText: t.aboutMe),
              maxLines: 3,
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty) ? t.fieldRequired : null,
              onChanged: (value) => cvData.about = value.trim(),
              onSaved: (v) => cvData.about = v!.trim(),
            ),
            const SizedBox(height: 16),
            _buildInputSection(
              context: context,
              title: t.experiences,
              controller: ctrlExp,
              list: cvData.experiences,
              onAdd: () {
                if (ctrlExp.text.trim().isNotEmpty) {
                  setState(() {
                    cvData.experiences.add(ctrlExp.text.trim());
                    ctrlExp.clear();
                  });
                }
              },
              listWidget: ExperienceList(
                items: cvData.experiences,
                theme: template.theme.copyWith(
                  textTheme: GoogleFonts.getTextTheme(template.fontFamily),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInputSection(
              context: context,
              title: t.educations,
              controller: ctrlEdu,
              list: cvData.educations,
              onAdd: () {
                if (ctrlEdu.text.trim().isNotEmpty) {
                  setState(() {
                    cvData.educations.add(ctrlEdu.text.trim());
                    ctrlEdu.clear();
                  });
                }
              },
              listWidget: EducationList(
                items: cvData.educations,
                theme: template.theme.copyWith(
                  textTheme: GoogleFonts.getTextTheme(template.fontFamily),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInputSection(
              context: context,
              title: t.skills,
              controller: ctrlSkill,
              list: cvData.skills,
              onAdd: () {
                if (ctrlSkill.text.trim().isNotEmpty) {
                  setState(() {
                    cvData.skills.add(ctrlSkill.text.trim());
                    ctrlSkill.clear();
                  });
                }
              },
              listWidget: Wrap(
                spacing: 6,
                children:
                    cvData.skills
                        .map(
                          (s) => SkillChip(
                            label: s,
                            theme: template.theme.copyWith(
                              textTheme: GoogleFonts.getTextTheme(
                                template.fontFamily,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Section(
              title: t.socialLinks,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: selectedSocial,
                          items:
                              socialItems
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSocial = value ?? 'Escolha';
                            });
                          },
                          decoration: InputDecoration(labelText: t.socialName),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: ctrlUrl,
                          decoration: InputDecoration(labelText: t.socialUrl),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedSocial != 'Escolha' &&
                          ctrlUrl.text.trim().isNotEmpty) {
                        setState(() {
                          cvData.socials.add({
                            'name': selectedSocial,
                            'url': ctrlUrl.text.trim(),
                          });
                          selectedSocial = 'Escolha';
                          ctrlUrl.clear();
                        });
                      }
                    },
                    child: Text(t.add),
                  ),
                  Column(
                    children:
                        cvData.socials
                            .map(
                              (s) =>
                                  SocialLink(name: s['name']!, url: s['url']!),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(t.save),
              onPressed: () => _saveData(context, cvData, t),
            ),
          ],
        ),
      ),
    );
  }
}
