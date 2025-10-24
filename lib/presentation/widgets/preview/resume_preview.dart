import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/resume/resume_session_provider.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/data/models/cv_model.dart';
import 'package:intelliresume/di.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/presentation/widgets/preview/widgets/certificate_list.dart';
import 'package:intelliresume/presentation/widgets/preview/widgets/education_list.dart';
import 'package:intelliresume/presentation/widgets/preview/widgets/experience_list.dart';
import 'package:intelliresume/presentation/widgets/preview/widgets/project_list.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/cv_data.dart';
import '../../../domain/entities/user_profile.dart';
import 'widgets/header_section.dart';
import 'widgets/skill_chip.dart';
import 'widgets/social_link.dart';
import 'package:intelliresume/core/providers/editor/editor_providers.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (userData == null) {
      return Center(child: Text(l10n.userNotFound));
    }

    return Container(
      color: colorScheme.surface.withOpacity(0.5),
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
            l10n,
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
    AppLocalizations l10n,
  ) {
    void saveResume(ResumeStatus status) async {
      final userId = ref.read(userProfileProvider).value?.uid;
      if (userId == null || data == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.saveError)));
        return;
      }

      final location = GoRouterState.of(context).uri.toString();
      var resumeId = location.split('/').last;

      final isNewResume = resumeId == 'new';
      if (isNewResume) {
        resumeId = const Uuid().v4();
      }

      final originalCvModel =
          ref.read(cvModelProvider(isNewResume ? 'new' : resumeId)).value;

      final resumeToSave = CVModel(
        id: resumeId,
        title: l10n.resumePreview_defaultResumeTitle(
            user?.name ?? l10n.profilePage_defaultUserName), // Internationalized
        data: data,
        dateCreated: originalCvModel?.dateCreated ?? DateTime.now(),
        lastModified: DateTime.now(),
        status: status,
      );

      try {
        final useCase = ref.read(saveResumeUsecaseProvider);
        await useCase(userId, resumeToSave);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));

        if (isNewResume) {
          context.go('/editor/$resumeId');
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.saveErrorPrefix} $e')));
      }
    }

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
      return Semantics(
        label: l10n.resumePreview_sectionEditSemanticLabel(
            title.toLowerCase()), // Internationalized
        button: true,
        child: InkWell(
          onTap: () => onSectionEdit(sectionType, null),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(title, style: textTheme.titleMedium),
                  ),
                  const SizedBox(height: 16),
                  if (isEmpty)
                    buildEmptyState(
                      icon: emptyStateIcon,
                      message: emptyStateText,
                    )
                  else
                    child,
                ],
              ),
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
          title: l10n.aboutMe,
          emptyStateText: l10n.aboutMeEmptyPlaceholder,
          emptyStateIcon: Icons.person_outline,
          isEmpty: data?.about?.isEmpty ?? true,
          sectionType: SectionType.about,
          child: SelectableText(
            data?.about ?? "",
            style: textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),

        buildSectionCard(
          title: l10n.objective,
          emptyStateText: l10n.objectivesEmptyPlaceholder,
          emptyStateIcon: Icons.track_changes_outlined,
          isEmpty: data?.objective?.isEmpty ?? true,
          sectionType: SectionType.objective,
          child: SelectableText(
            data?.objective ?? "",
            style: textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),

        buildSectionCard(
          title: l10n.experiences,
          emptyStateText: l10n.experiencesEmptyPlaceholder,
          emptyStateIcon: Icons.work_outline,
          isEmpty: data!.experiences.isEmpty,
          sectionType: SectionType.experience,
          child: ExperienceList(items: data.experiences, theme: textTheme),
        ),

        buildSectionCard(
          title: l10n.educations,
          emptyStateText: l10n.educationsEmptyPlaceholder,
          emptyStateIcon: Icons.school_outlined,
          isEmpty: data.educations.isEmpty,
          sectionType: SectionType.education,
          child: EducationList(items: data.educations, theme: textTheme),
        ),

        buildSectionCard(
          title: l10n.skills,
          emptyStateText: l10n.skillsEmptyPlaceholder,
          emptyStateIcon: Icons.lightbulb_outline,
          isEmpty: data.skills.isEmpty,
          sectionType: SectionType.skill,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                data.skills.asMap().entries.map((entry) {
                  return Semantics(
                    label: l10n.resumePreview_skillEditSemanticLabel(
                        entry.value.name ?? '',
                        entry.value.level.toString()), // Internationalized
                    button: true,
                    child: InkWell(
                      onTap: () => onSectionEdit(SectionType.skill, entry.key),
                      child: SkillChip(skills: entry.value),
                    ),
                  );
                }).toList(),
          ),
        ),

        buildSectionCard(
          title: l10n.socialLinks,
          emptyStateText: l10n.socialLinksEmptyPlaceholder,
          emptyStateIcon: Icons.link_outlined,
          isEmpty: data.socials.isEmpty,
          sectionType: SectionType.social,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                data.socials.asMap().entries.map((entry) {
                  return Semantics(
                    label: l10n.resumePreview_socialLinkEditSemanticLabel(
                        entry.value.platform ?? ''), // Internationalized
                    button: true,
                    child: InkWell(
                      onTap: () => onSectionEdit(SectionType.social, entry.key),
                      child: SocialLink(social: entry.value, theme: textTheme),
                    ),
                  );
                }).toList(),
          ),
        ),

        buildSectionCard(
          title: l10n.projects,
          emptyStateText: l10n.projectsEmptyPlaceholder,
          emptyStateIcon: Icons.link_outlined,
          isEmpty: data.projects.isEmpty,
          sectionType: SectionType.project,
          child: ProjectList(items: data.projects, theme: textTheme),
        ),

        buildSectionCard(
          title: l10n.certificates,
          emptyStateText: l10n.certificatesEmptyPlaceholder,
          emptyStateIcon: Icons.link_outlined,
          isEmpty: data.certificates.isEmpty,
          sectionType: SectionType.certificate,
          child: CertificateList(items: data.certificates, theme: textTheme),
        ),
        // Action Buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => saveResume(ResumeStatus.draft),
                child: Text(l10n.saveDraft),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => saveResume(ResumeStatus.finalized),
                child: Text(l10n.saveAndFinalize),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
