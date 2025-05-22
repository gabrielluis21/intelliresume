// lib/pages/resume_preview_page.dart

import 'package:flutter/material.dart';
import '../widgets/header_section.dart';
import '../widgets/section.dart';
import '../widgets/experience_list.dart';
import '../widgets/education_list.dart';
import '../widgets/skill_chip.dart';
import '../widgets/social_link.dart';
import '../../core/utils/app_localizations.dart';

class ResumePreviewPage extends StatelessWidget {
  final String about;
  final List<String> experiences;
  final List<String> educations;
  final List<String> skills;
  final List<Map<String, String>> socials;

  const ResumePreviewPage({
    super.key,
    required this.about,
    required this.experiences,
    required this.educations,
    required this.skills,
    required this.socials,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    final content = SingleChildScrollView(
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

    // Se for web e largura > 600, retorna somente o conteúdo (usado em split-view)
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? content
        : Scaffold(appBar: AppBar(title: Text(t.previewPdf)), body: content);
  }
}
