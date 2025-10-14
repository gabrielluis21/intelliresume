import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import 'package:intelliresume/core/providers/resume/cv_provider.dart';
import 'package:intelliresume/core/providers/resume/resume_session_provider.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/data/models/cv_model.dart';
import 'package:intelliresume/di.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/cv_data.dart';
import '../../../domain/entities/user_profile.dart';
import 'widgets/header_section.dart';
import 'widgets/experience_list.dart';
import 'widgets/education_list.dart';
import 'widgets/skill_chip.dart';
import 'widgets/social_link.dart';
import 'package:intelliresume/presentation/widgets/preview/widgets/project_list.dart';
import 'package:intelliresume/presentation/widgets/preview/widgets/certificate_list.dart';
import '../../../core/utils/app_localizations.dart';
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

    void saveResume(ResumeStatus status) async {
      final userId = ref.read(userProfileProvider).value?.uid;
      if (userId == null || data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro: Não foi possível salvar. Tente novamente.'),
          ),
        );
        return;
      }

      // Extrai o ID da rota atual
      final location = GoRouterState.of(context).uri.toString();
      var resumeId = location.split('/').last;

      final isNewResume = resumeId == 'new';
      if (isNewResume) {
        resumeId = const Uuid().v4(); // Gera um novo ID único
      }

      // Busca o CVModel original para preservar a data de criação
      final originalCvModel =
          ref.read(cvModelProvider(isNewResume ? 'new' : resumeId)).value;

      final resumeToSave = CVModel(
        id: resumeId,
        title: 'Currículo de ${user?.name ?? "Usuário"}', // Título provisório
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
        ).showSnackBar(SnackBar(content: Text('Currículo salvo com sucesso!')));

        // Se for um novo currículo, atualiza a URL para o novo ID
        if (isNewResume) {
          context.go('/editor/$resumeId');
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
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
        label:
            'Seção de ${title.toLowerCase()}, toque para editar o conteúdo desta seção',
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
          title: 'Sobre Mim',
          emptyStateText: 'Faça um breve resumo sobre você.',
          emptyStateIcon: Icons.person_outline,
          isEmpty: data?.about?.isEmpty ?? true,
          sectionType: SectionType.about,
          child: SelectableText(
            data?.about ?? "",
            style: textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),

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
                  return Semantics(
                    label:
                        'Habilidade: ${entry.value.name}, nível ${entry.value.level}. Toque para editar.',
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
                  return Semantics(
                    label:
                        'Link social: ${entry.value.platform}. Toque para editar.',
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
          title: t.projects,
          emptyStateText: 'Seus projetos aparecerão aqui.',
          emptyStateIcon: Icons.link_outlined,
          isEmpty: data.projects?.isEmpty ?? true,
          sectionType: SectionType.project,
          child: ProjectList(items: data.projects!, theme: textTheme),
        ),

        buildSectionCard(
          title: t.certificates,
          emptyStateText: 'Seus certificados aparecerão aqui.',
          emptyStateIcon: Icons.link_outlined,
          isEmpty: data.certificates?.isEmpty ?? true,
          sectionType: SectionType.certificate,
          child: CertificateList(items: data.certificates!, theme: textTheme),
        ),
        // Botões de Ação
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => saveResume(ResumeStatus.draft),
                child: const Text('Salvar Rascunho'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => saveResume(ResumeStatus.finalized),
                child: const Text('Salvar e Finalizar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
