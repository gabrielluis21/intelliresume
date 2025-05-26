// Melhorias aplicadas:
// - Separação de responsabilidades (SOLID)
// - Extração de widgets para limpeza de código
// - Validações mais robustas
// - Melhor UX para mobile e PWA (scroll suave, botões fixos, feedback claro)
// - Internationalization support mantido
// - Padding e espaçamento consistente para acessibilidade

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/header_section.dart';
import '../widgets/section.dart';
import '../widgets/experience_list.dart';
import '../widgets/education_list.dart';
import '../widgets/skill_chip.dart';
import '../widgets/social_link.dart';
import '../../core/utils/app_localizations.dart';

class ResumeFormPage extends StatefulWidget {
  const ResumeFormPage({super.key});

  @override
  State<ResumeFormPage> createState() => _ResumeFormPageState();
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  final _formKey = GlobalKey<FormState>();

  String about = '';
  final experiences = <String>[];
  final educations = <String>[];
  final skills = <String>[];
  final socials = <Map<String, String>>[];

  final ctrlExp = TextEditingController();
  final ctrlEdu = TextEditingController();
  final ctrlSkill = TextEditingController();
  final ctrlUrl = TextEditingController();
  String selectedSocial = 'Escolha';

  final socialItems = ['Escolha', 'GitHub', 'LinkedIn', 'Twitter', 'Website'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      about = prefs.getString('about') ?? '';
      experiences.addAll(
        List<String>.from(jsonDecode(prefs.getString('exp') ?? '[]')),
      );
      educations.addAll(
        List<String>.from(jsonDecode(prefs.getString('edu') ?? '[]')),
      );
      skills.addAll(
        List<String>.from(jsonDecode(prefs.getString('skills') ?? '[]')),
      );
      socials.addAll(
        List<Map<String, String>>.from(
          jsonDecode(prefs.getString('socials') ?? '[]'),
        ),
      );
    });
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('about', about);
    await prefs.setString('exp', jsonEncode(experiences));
    await prefs.setString('edu', jsonEncode(educations));
    await prefs.setString('skills', jsonEncode(skills));
    await prefs.setString('socials', jsonEncode(socials));

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).save)));
  }

  Widget _buildInputSection({
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
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isWide = MediaQuery.of(context).size.width > 600;

    Widget formContent = Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: about,
              decoration: InputDecoration(labelText: t.aboutMe),
              maxLines: 3,
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty) ? t.fieldRequired : null,
              onSaved: (v) => about = v!.trim(),
            ),
            const SizedBox(height: 16),
            _buildInputSection(
              title: t.experiences,
              controller: ctrlExp,
              list: experiences,
              onAdd: () {
                if (ctrlExp.text.trim().isNotEmpty) {
                  setState(() => experiences.add(ctrlExp.text.trim()));
                  ctrlExp.clear();
                }
              },
              listWidget: ExperienceList(items: experiences),
            ),
            const SizedBox(height: 16),
            _buildInputSection(
              title: t.educations,
              controller: ctrlEdu,
              list: educations,
              onAdd: () {
                if (ctrlEdu.text.trim().isNotEmpty) {
                  setState(() => educations.add(ctrlEdu.text.trim()));
                  ctrlEdu.clear();
                }
              },
              listWidget: EducationList(items: educations),
            ),
            const SizedBox(height: 16),
            _buildInputSection(
              title: t.skills,
              controller: ctrlSkill,
              list: skills,
              onAdd: () {
                if (ctrlSkill.text.trim().isNotEmpty) {
                  setState(() => skills.add(ctrlSkill.text.trim()));
                  ctrlSkill.clear();
                }
              },
              listWidget: Wrap(
                spacing: 6,
                children: skills.map((s) => SkillChip(label: s)).toList(),
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
                          onChanged:
                              (value) =>
                                  setState(() => selectedSocial = value!),
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
                        setState(
                          () => socials.add({
                            'name': selectedSocial,
                            'url': ctrlUrl.text.trim(),
                          }),
                        );
                        selectedSocial = 'Escolha';
                        ctrlUrl.clear();
                      }
                    },
                    child: Text(t.add),
                  ),
                  Column(
                    children:
                        socials
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
              onPressed: _saveData,
            ),
          ],
        ),
      ),
    );

    Widget previewContent = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderSection(title: t.appTitle),
          Section(title: t.aboutMe, child: Text(about)),
          Section(
            title: t.experiences,
            child: ExperienceList(items: experiences),
          ),
          Section(title: t.educations, child: EducationList(items: educations)),
          Section(
            title: t.skills,
            child: Wrap(
              spacing: 6,
              children: skills.map((s) => SkillChip(label: s)).toList(),
            ),
          ),
          Section(
            title: t.socialLinks,
            child: Column(
              children:
                  socials
                      .map((s) => SocialLink(name: s['name']!, url: s['url']!))
                      .toList(),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isWide) {
            return Row(
              children: [
                Expanded(child: formContent),
                const VerticalDivider(),
                Expanded(child: previewContent),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [formContent, const Divider(), previewContent],
              ),
            );
          }
        },
      ),
    );
  }
}
