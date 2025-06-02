import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelliresume/core/providers/resume_template_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/app_localizations.dart';
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
  String selectedSocial = 'Escolha';

  final socialItems = ['Escolha', 'GitHub', 'LinkedIn', 'Twitter', 'Website'];

  final ctrlExp = TextEditingController();
  final ctrlEdu = TextEditingController();
  final ctrlSkill = TextEditingController();
  final ctrlUrl = TextEditingController();

  // Mapeamento de ícones para persistência
  final Map<String, IconData> socialIcons = {
    'GitHub': FontAwesomeIcons.github,
    'LinkedIn': FontAwesomeIcons.linkedin,
    'Twitter': FontAwesomeIcons.twitter,
    'Website': FontAwesomeIcons.globe,
  };

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

      // Carregar redes sociais com tratamento de ícones
      final socialData = jsonDecode(prefs.getString('socials') ?? '[]');
      ref
          .read(cvDataProvider)
          .socials
          .addAll(
            List<Map<String, String>>.from(socialData).map((social) {
              return {'type': social['type'] ?? '', 'url': social['url'] ?? ''};
            }).toList(),
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

    // Salvar apenas tipo e URL (ícones são mapeados)
    await prefs.setString(
      'socials',
      jsonEncode(
        data.socials
            .map((s) => {'type': s['type']!, 'url': s['url']!})
            .toList(),
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.save)));
  }

  Widget _buildInputSection({
    Widget? input,
    required BuildContext context,
    required String title,
    required TextEditingController? controller,
    required List<dynamic> list,
    required VoidCallback onAdd,
    required Widget listWidget,
  }) {
    final t = AppLocalizations.of(context);
    final template = ref.watch(selectedTemplateProvider);
    return Section(
      title: title,
      titleStyle:
          template.theme
              .copyWith(
                textTheme: GoogleFonts.getTextTheme(template.fontFamily),
              )
              .textTheme,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          input ??
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
    final cv = ref.watch(cvDataProvider);
    final cvData = ref.read(cvDataProvider.notifier);
    final template = ref.watch(selectedTemplateProvider);
    final t = AppLocalizations.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de Objetivo
            TextFormField(
              initialValue: "Objetivos",
              decoration: InputDecoration(labelText: t.objective),
              maxLines: 3,
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty) ? t.fieldRequired : null,
              onChanged: (value) => cvData.updateObjective(value.trim()),
              onSaved: (v) => cvData.updateObjective(v?.trim() ?? ''),
            ),
            const SizedBox(height: 16),

            // Seção de Experiências
            _buildInputSection(
              context: context,
              title: t.experiences,
              controller: ctrlExp,
              list: cv.experiences,
              onAdd: () {
                if (ctrlExp.text.trim().isNotEmpty) {
                  setState(() {
                    cvData.updateExperiences(
                      experiences: [...cv.experiences, ctrlExp.text.trim()],
                    );
                    ctrlExp.clear();
                  });
                }
              },
              listWidget: ExperienceList(
                items: cv.experiences,
                theme:
                    template.theme
                        .copyWith(
                          textTheme: GoogleFonts.getTextTheme(
                            template.fontFamily,
                          ),
                        )
                        .textTheme,
              ),
            ),
            const SizedBox(height: 16),

            // Seção de Educação
            _buildInputSection(
              context: context,
              title: t.educations,
              controller: ctrlEdu,
              list: cv.educations,
              onAdd: () {
                if (ctrlEdu.text.trim().isNotEmpty) {
                  setState(() {
                    cvData.updateEducations(
                      educations: [...cv.educations, ctrlEdu.text.trim()],
                    );
                    ctrlEdu.clear();
                  });
                }
              },
              listWidget: EducationList(
                items: cv.educations,
                theme:
                    template.theme
                        .copyWith(
                          textTheme: GoogleFonts.getTextTheme(
                            template.fontFamily,
                          ),
                        )
                        .textTheme,
              ),
            ),
            const SizedBox(height: 16),

            // Seção de Habilidades
            _buildInputSection(
              context: context,
              title: t.skills,
              controller: ctrlSkill,
              list: cv.skills,
              onAdd: () {
                if (ctrlSkill.text.trim().isNotEmpty) {
                  setState(() {
                    cvData.updateSkills(
                      skills: [...cv.skills, ctrlSkill.text.trim()],
                    );
                    ctrlSkill.clear();
                  });
                }
              },
              listWidget: Wrap(
                spacing: 6,
                children:
                    cv.skills
                        .map(
                          (s) => SkillChip(
                            label: s,
                            theme:
                                template.theme
                                    .copyWith(
                                      textTheme: GoogleFonts.getTextTheme(
                                        template.fontFamily,
                                      ),
                                    )
                                    .textTheme,
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Seção de Redes Sociais (Modificada)
            _buildInputSection(
              context: context,
              title: t.socialLinks,
              input: Row(
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
              controller: ctrlUrl,
              list: cv.socials,
              onAdd: () {
                if (selectedSocial != 'Escolha' &&
                    ctrlUrl.text.trim().isNotEmpty) {
                  setState(() {
                    cvData.updateSocials(
                      socials: [
                        ...cv.socials,
                        {'type': selectedSocial, 'url': ctrlUrl.text.trim()},
                      ],
                    );
                    selectedSocial = 'Escolha';
                    ctrlUrl.clear();
                  });
                }
              },
              // Layout horizontal com Wrap
              listWidget: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    cv.socials.asMap().entries.map((entry) {
                      final index = entry.key;
                      final s = entry.value;
                      return SocialLink(
                        icon: socialIcons[s['type']] ?? FontAwesomeIcons.link,
                        name: s['type']!,
                        url: s['url']!,
                        textTheme:
                            template.theme
                                .copyWith(
                                  textTheme: GoogleFonts.getTextTheme(
                                    template.fontFamily,
                                  ),
                                )
                                .textTheme,
                        onDeleted: () {
                          setState(() {
                            final newSocials = List<Map<String, String>>.from(
                              cv.socials,
                            );
                            newSocials.removeAt(index);
                            cvData.updateSocials(socials: newSocials);
                          });
                        },
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(t.save),
              onPressed: () => _saveData(context, cv, t),
            ),
          ],
        ),
      ),
    );
  }
}
