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
  final _form = GlobalKey<FormState>();
  String about = '';
  final experiences = <String>[];
  final educations = <String>[];
  final skills = <String>[];
  final socials = <Map<String, String>>[];

  final ctrlExp = TextEditingController();
  final ctrlEdu = TextEditingController();
  final ctrlSkill = TextEditingController();
  final ctrlName = TextEditingController();
  final ctrlUrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      about = p.getString('about') ?? '';
      experiences.addAll(
        List<String>.from(jsonDecode(p.getString('exp') ?? '[]')),
      );
      educations.addAll(
        List<String>.from(jsonDecode(p.getString('edu') ?? '[]')),
      );
      skills.addAll(
        List<String>.from(jsonDecode(p.getString('skills') ?? '[]')),
      );
      socials.addAll(
        List<Map<String, String>>.from(
          jsonDecode(p.getString('socials') ?? '[]'),
        ),
      );
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    final p = await SharedPreferences.getInstance();
    await p.setString('about', about);
    await p.setString('exp', jsonEncode(experiences));
    await p.setString('edu', jsonEncode(educations));
    await p.setString('skills', jsonEncode(skills));
    await p.setString('socials', jsonEncode(socials));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).save)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isWide = MediaQuery.of(context).size.width > 600;

    Widget formCol = Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: about,
            decoration: InputDecoration(labelText: t.aboutMe),
            maxLines: 3,
            validator: (v) => v!.isEmpty ? t.fieldRequired : null,
            onSaved: (v) => about = v!,
          ),
          const SizedBox(height: 16),
          Section(
            title: t.experiences,
            child: Column(
              children: [
                TextField(
                  controller: ctrlExp,
                  decoration: InputDecoration(labelText: t.add),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (ctrlExp.text.trim().isNotEmpty) {
                      setState(() => experiences.add(ctrlExp.text.trim()));
                      ctrlExp.clear();
                    }
                  },
                  child: Text(t.add),
                ),
                ExperienceList(items: experiences),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Section(
            title: t.educations,
            child: Column(
              children: [
                TextField(
                  controller: ctrlEdu,
                  decoration: InputDecoration(labelText: t.add),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (ctrlEdu.text.trim().isNotEmpty) {
                      setState(() => educations.add(ctrlEdu.text.trim()));
                      ctrlEdu.clear();
                    }
                  },
                  child: Text(t.add),
                ),
                EducationList(items: educations),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Section(
            title: t.skills,
            child: Column(
              children: [
                TextField(
                  controller: ctrlSkill,
                  decoration: InputDecoration(labelText: t.add),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (ctrlSkill.text.trim().isNotEmpty) {
                      setState(() => skills.add(ctrlSkill.text.trim()));
                      ctrlSkill.clear();
                    }
                  },
                  child: Text(t.add),
                ),
                Wrap(
                  spacing: 6,
                  children: skills.map((s) => SkillChip(label: s)).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Section(
            title: t.socialLinks,
            child: Column(
              children: [
                TextField(
                  controller: ctrlName,
                  decoration: InputDecoration(labelText: t.add),
                ),
                TextField(
                  controller: ctrlUrl,
                  decoration: InputDecoration(labelText: t.add),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (ctrlName.text.trim().isNotEmpty &&
                        ctrlUrl.text.trim().isNotEmpty) {
                      setState(
                        () => socials.add({
                          'name': ctrlName.text,
                          'url': ctrlUrl.text,
                        }),
                      );
                      ctrlName.clear();
                      ctrlUrl.clear();
                    }
                  },
                  child: Text(t.add),
                ),
                Column(
                  children:
                      socials
                          .map(
                            (s) => SocialLink(name: s['name']!, url: s['url']!),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(t.save),
              onPressed: _save,
            ),
          ),
        ],
      ),
    );

    Widget previewCol = Padding(
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
      body:
          isWide
              ? Row(
                children: [
                  Expanded(child: SingleChildScrollView(child: formCol)),
                  VerticalDivider(),
                  Expanded(child: SingleChildScrollView(child: previewCol)),
                ],
              )
              : ListView(children: [formCol, Divider(), previewCol]),
    );
  }
}
