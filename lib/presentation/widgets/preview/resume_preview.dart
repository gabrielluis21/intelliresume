// lib/pages/resume_preview_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/user_provider.dart';
import '../../../data/models/cv_data.dart';
import '../../../domain/entities/user_profile.dart';
import 'widgets/header_section.dart';
import 'widgets/preview_section.dart';
import 'widgets/experience_list.dart';
import 'widgets/education_list.dart';
import 'widgets/skill_chip.dart';
import 'widgets/social_link.dart';
import '../../../core/utils/app_localizations.dart';
import '../../../core/providers/cv_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ResumePreview extends ConsumerWidget {
  const ResumePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final cvData = ref.watch(resumeProvider);
    final textTheme = GoogleFonts.getTextTheme(
      "Roboto",
      Theme.of(context).textTheme,
    );

    return user.when(
      data: (user) {
        if (user == null) {
          return Center(child: Text('Nenhum dado disponível'));
        }
        return Theme(
          data: Theme.of(context),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMainContent(context, textTheme, user, cvData),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (error, stack) => Center(child: Text('Erro: $error')),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    TextTheme textTheme,
    UserProfile? user,
    ResumeData? data,
  ) {
    final t = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderSection(user: user, theme: textTheme),
        const SizedBox(height: 8),
        PreviewSection(
          title: t.objective,
          titleStyle: textTheme,
          child: Text(
            (data != null && data.objective!.isEmpty)
                ? t.noObjectives
                : "${data?.objective}",
            style: textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        PreviewSection(
          title: t.experiences,
          titleStyle: textTheme,
          child:
              data!.experiences!.isEmpty
                  ? Text('Sem experiencias adicionadas')
                  : ExperienceList(items: data.experiences!, theme: textTheme),
        ),
        const SizedBox(height: 16),
        PreviewSection(
          title: t.educations,
          titleStyle: textTheme,
          child:
              data.educations!.isEmpty
                  ? Text('Sem escolaridade adicionada')
                  : EducationList(items: data.educations!, theme: textTheme),
        ),
        const SizedBox(height: 16),
        PreviewSection(
          title: t.skills,
          titleStyle: textTheme,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                data.skills!
                    .map((skill) => SkillChip(skill: skill, theme: textTheme))
                    .toList(),
          ),
        ),
        const SizedBox(height: 16),
        PreviewSection(
          title: t.socialLinks,
          titleStyle: textTheme,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                data.socials!
                    .map(
                      (social) => SocialLink(social: social, theme: textTheme),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
