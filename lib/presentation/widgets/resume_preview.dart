// lib/pages/resume_preview_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/resume_template_provider.dart';
import 'package:intelliresume/core/providers/user_provider.dart';
import '../../domain/entities/user_profile.dart';
//import 'header_section.dart';
import 'section.dart';
import 'experience_list.dart';
import 'education_list.dart';
import 'skill_chip.dart';
import 'social_link.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/providers/cv_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ResumePreview extends ConsumerWidget {
  const ResumePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = ref.watch(selectedTemplateProvider);
    final cvData = ref.watch(cvDataProvider);
    final user = ref.watch(userProfileProvider);

    final textTheme = GoogleFonts.getTextTheme(
      template.fontFamily,
    ).apply(bodyColor: Colors.black, displayColor: Colors.black);

    return Theme(
      data: template.theme.copyWith(textTheme: textTheme),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              template.columns == 2
                  ? Row(
                    children: [
                      Expanded(
                        child: _buildSidebar(context, textTheme, user, cvData),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        child: _buildMainContent(
                          context,
                          textTheme,
                          user,
                          cvData,
                        ),
                      ),
                    ],
                  )
                  : SingleChildScrollView(
                    child: _buildMainContent(context, textTheme, user!, cvData),
                  ),
        ),
      ),
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    TextTheme textTheme,
    UserProfile? user,
    CVData data,
  ) {
    final t = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Section(
          title: t.contactInfo,
          titleStyle: textTheme,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(user?.email ?? ''),
              Text('Telefone: ${user?.phone ?? '(00) 00000-0000'}'),
              Row(
                children:
                    data.socials
                        .map(
                          (link) => SocialLink(
                            icon: link['icon'],
                            name: link['name'],
                            url: link['url'],
                            textTheme: textTheme,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16),
              Section(
                title: t.skills,
                titleStyle: textTheme,
                child: Wrap(
                  children:
                      data.skills
                          .map(
                            (skill) =>
                                SkillChip(label: skill, theme: textTheme),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    TextTheme textTheme,
    UserProfile? user,
    CVData data,
  ) {
    final t = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(user?.name ?? '', style: textTheme.bodyLarge),
        const SizedBox(height: 8),
        Section(
          title: t.objective,
          titleStyle: textTheme,
          child: Text(data.objective, style: textTheme.bodyMedium),
        ),
        const SizedBox(height: 16),
        Section(
          title: t.experiences,
          titleStyle: textTheme,
          child: ExperienceList(items: data.experiences, theme: textTheme),
        ),
        const SizedBox(height: 16),
        Section(
          title: t.educations,
          titleStyle: textTheme,
          child: EducationList(items: data.educations, theme: textTheme),
        ),
      ],
    );
  }
}
