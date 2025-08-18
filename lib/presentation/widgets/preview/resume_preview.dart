import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/editor_providers.dart';
import 'package:intelliresume/core/templates/resume_template.dart';
import '../../../data/models/cv_data.dart';
import '../../../domain/entities/user_profile.dart';
import 'widgets/header_section.dart';
import 'widgets/experience_list.dart';
import 'widgets/education_list.dart';
import 'widgets/skill_chip.dart';
import 'widgets/social_link.dart';
import '../../../core/utils/app_localizations.dart';

class ResumePreview extends ConsumerWidget {
  final ResumeData? resumeData;
  final UserProfile? userData;
  final Function(SectionType, int?) onSectionEdit;

  const ResumePreview({
    super.key,
    required this.resumeData,
    required this.userData,
    required this.onSectionEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (userData == null) {
      return const Center(child: Text('Usuário não encontrado'));
    }

    return Container(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 80), // Space for export button
        children: [
          _buildMainContent(
            context,
            textTheme,
            colorScheme,
            userData,
            resumeData,
            ref,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    UserProfile? user,
    ResumeData? data,
    WidgetRef ref,
  ) {
    final t = AppLocalizations.of(context);

    Widget buildEmptyState({required IconData icon, required String message}) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    Widget buildSectionCard({
      required String title,
      required String emptyStateText,
      required IconData emptyStateIcon,
      required bool isEmpty,
      required Widget child,
      required SectionType sectionType,
    }) {
      return InkWell(
        onTap: () => onSectionEdit(sectionType, null),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: 16),
                if (isEmpty)
                  buildEmptyState(icon: emptyStateIcon, message: emptyStateText)
                else
                  child,
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          margin: const EdgeInsets.all(0),
          child: HeaderSection(user: user, theme: textTheme),
        ),
        const SizedBox(height: 8),

        buildSectionCard(
          title: t.objective,
          emptyStateText: t.noObjectives,
          emptyStateIcon: Icons.track_changes_outlined,
          isEmpty: data?.objective?.isEmpty ?? true,
          sectionType: SectionType.objective,
          child: SelectableText(
            data?.objective ?? "",
            style: textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),

        buildSectionCard(
          title: t.experiences,
          emptyStateText: 'Suas experiências profissionais aparecerão aqui.',
          emptyStateIcon: Icons.work_outline,
          isEmpty: data?.experiences?.isEmpty ?? true,
          sectionType: SectionType.experience,
          child: ExperienceList(items: data!.experiences!, theme: textTheme),
        ),

        buildSectionCard(
          title: t.educations,
          emptyStateText: 'Suas formações acadêmicas aparecerão aqui.',
          emptyStateIcon: Icons.school_outlined,
          isEmpty: data.educations?.isEmpty ?? true,
          sectionType: SectionType.education,
          child: EducationList(items: data.educations!, theme: textTheme),
        ),

        buildSectionCard(
          title: t.skills,
          emptyStateText: 'Suas habilidades e competências aparecerão aqui.',
          emptyStateIcon: Icons.lightbulb_outline,
          isEmpty: data.skills?.isEmpty ?? true,
          sectionType: SectionType.skill,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                data.skills!.asMap().entries.map((entry) {
                  return InkWell(
                    onTap: () => onSectionEdit(SectionType.skill, entry.key),
                    child: SkillChip(skills: entry.value),
                  );
                }).toList(),
          ),
        ),

        buildSectionCard(
          title: t.socialLinks,
          emptyStateText: 'Seus links (LinkedIn, GitHub, etc) aparecerão aqui.',
          emptyStateIcon: Icons.link_outlined,
          isEmpty: data.socials?.isEmpty ?? true,
          sectionType: SectionType.social,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                data.socials!.asMap().entries.map((entry) {
                  return InkWell(
                    onTap: () => onSectionEdit(SectionType.social, entry.key),
                    child: SocialLink(social: entry.value, theme: textTheme),
                  );
                }).toList(),
          ),
        ),

        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text("Exportar para PDF"),
            onPressed: () => _showExportOptions(context, ref),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
      ],
    );
  }

  void _showExportOptions(BuildContext context, WidgetRef ref) {
    // ... (o resto do código permanece o mesmo)
  }

  Future<void> _exportResume(
    BuildContext context,
    WidgetRef ref,
    ResumeTemplate template,
  ) async {
    // ... (o resto do código permanece o mesmo)
  }
}
