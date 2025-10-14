import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/resume/cv_provider.dart';
import 'package:intelliresume/core/providers/editor/editor_providers.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/presentation/widgets/form/widgets/about_me_form.dart';
import 'package:intelliresume/presentation/widgets/form/widgets/certificate_form.dart';
import 'package:intelliresume/presentation/widgets/form/widgets/objective_form.dart';
import 'package:intelliresume/presentation/widgets/form/widgets/project_form.dart';

import 'widgets/education_form.dart';
import 'widgets/experience_form.dart';
import 'widgets/skill_form.dart';
import 'widgets/social_form.dart';

class ResumeForm extends ConsumerStatefulWidget {
  final ResumeData? resume;
  const ResumeForm({super.key, this.resume});

  @override
  ConsumerState<ResumeForm> createState() => _ResumeFormState();
}

class _ResumeFormState extends ConsumerState<ResumeForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State for the focused editor
  int _currentExperienceIndex = 0;
  int _currentEducationIndex = 0;
  int _currentSkillIndex = 0;
  int _currentSocialIndex = 0;
  int _currentProjectIndex = 0;
  int _currentCertificateIndex = 0;

  // Focus Nodes
  // A lógica de gerenciamento de foco foi revertida para estabilidade.

  final _tabs = <Widget>[
    const Tab(icon: Icon(Icons.person_search_outlined), text: 'Sobre Mim'),
    const Tab(icon: Icon(Icons.person_search_outlined), text: 'Objetivo'),
    const Tab(icon: Icon(Icons.work_outline), text: 'Experiência'),
    const Tab(icon: Icon(Icons.school_outlined), text: 'Educação'),
    const Tab(icon: Icon(Icons.lightbulb_outline), text: 'Habilidades'),
    const Tab(icon: Icon(Icons.link_outlined), text: 'Social'),
    const Tab(icon: Icon(Icons.folder_outlined), text: 'Projetos'),
    const Tab(icon: Icon(Icons.badge_outlined), text: 'Certificados'),
    const Tab(
      icon: Icon(Icons.accessibility_new_outlined),
      text: 'Acessibilidade',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialData = widget.resume ?? ResumeData.initial();
      ref.read(localResumeProvider.notifier).initialize(initialData);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleEditRequest(EditRequest request) {
    _tabController.animateTo(request.section.index);

    setState(() {
      switch (request.section) {
        case SectionType.about:
          break;
        case SectionType.experience:
          _currentExperienceIndex = request.index!;
          break;
        case SectionType.education:
          _currentEducationIndex = request.index!;
          break;
        case SectionType.skill:
          _currentSkillIndex = request.index!;
          break;
        case SectionType.social:
          _currentSocialIndex = request.index!;
          break;
        case SectionType.objective:
          break;
        case SectionType.project:
          _currentProjectIndex = request.index!;
          break;
        case SectionType.certificate:
          _currentCertificateIndex = request.index!;
          break;
      }
    });

    ref.read(editRequestProvider.notifier).state = null;
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFocusedEditorControls({
    required int currentIndex,
    required int totalItems,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
    required String itemLabel,
  }) {
    if (totalItems == 0) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: currentIndex > 0 ? onPrevious : null,
          tooltip: 'Anterior',
        ),
        Text(
          '$itemLabel ${currentIndex + 1} de $totalItems',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: currentIndex < totalItems - 1 ? onNext : null,
          tooltip: 'Próximo',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<EditRequest?>(editRequestProvider, (previous, next) {
      if (next != null) {
        _handleEditRequest(next);
      }
    });

    final resume = ref.watch(localResumeProvider);
    final textTheme = Theme.of(context).textTheme;

    final tabViews = <Widget>[
      // 1. Sobre Mim
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Sobre Mim', context),
            AboutMeForm(about: resume.about ?? ''),
          ],
        ),
      ),
      // 2. Objetivo
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Objetivo Profissional', context),
            ObjectiveForm(objective: resume.objective ?? ''),
          ],
        ),
      ),
      // 2. Experiências
      _buildFocusedEditorTab(
        context: context,
        resume: resume,
        itemLabel: 'Experiência',
        currentIndex: _currentExperienceIndex,
        totalItems: resume.experiences?.length ?? 0,
        formBuilder:
            (index) => ExperienceForm(
              key: ValueKey('exp-$index'),
              index: index,
              experience: resume.experiences![index],
            ),
        onPrevious: () => setState(() => _currentExperienceIndex--),
        onNext: () => setState(() => _currentExperienceIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addExperience(Experience());
          setState(() {
            _currentExperienceIndex = (resume.experiences?.length ?? 0);
          });
        },
        onRemove: () {
          ref
              .read(localResumeProvider.notifier)
              .removeExperience(_currentExperienceIndex);
          setState(() {
            _currentExperienceIndex = (_currentExperienceIndex - 1).clamp(
              0,
              100,
            );
          });
        },
      ),

      // 3. Formação Acadêmica
      _buildFocusedEditorTab(
        context: context,
        resume: resume,
        itemLabel: 'Formação',
        currentIndex: _currentEducationIndex,
        totalItems: resume.educations?.length ?? 0,
        formBuilder:
            (index) => EducationForm(
              key: ValueKey('edu-${(index + 1)}'),
              index: index,
              education: resume.educations![index],
            ),
        onPrevious: () => setState(() => _currentEducationIndex--),
        onNext: () => setState(() => _currentEducationIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addEducation(Education());
          setState(() {
            _currentEducationIndex = (resume.educations?.length ?? 0);
          });
        },
        onRemove: () {
          ref
              .read(localResumeProvider.notifier)
              .removeEducation(_currentEducationIndex);
          setState(() {
            _currentEducationIndex = (_currentEducationIndex - 1).clamp(0, 100);
          });
        },
      ),

      // 4. Habilidades
      _buildFocusedEditorTab(
        context: context,
        resume: resume,
        itemLabel: 'Habilidade',
        currentIndex: _currentSkillIndex,
        totalItems: resume.skills?.length ?? 0,
        formBuilder:
            (index) => SkillForm(
              key: ValueKey('skill-$index'),
              index: index,
              skill: resume.skills![index],
            ),
        onPrevious: () => setState(() => _currentSkillIndex--),
        onNext: () => setState(() => _currentSkillIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addSkill(Skill());
          setState(() {
            _currentSkillIndex = (resume.skills?.length ?? 0);
          });
        },
        onRemove: () {
          ref
              .read(localResumeProvider.notifier)
              .removeSkill(_currentSkillIndex);
          setState(() {
            _currentSkillIndex = (_currentSkillIndex - 1).clamp(0, 100);
          });
        },
      ),

      // 5. Redes Sociais
      _buildFocusedEditorTab(
        context: context,
        resume: resume,
        itemLabel: 'Link Social',
        currentIndex: _currentSocialIndex,
        totalItems: resume.socials?.length ?? 0,
        formBuilder:
            (index) => SocialForm(
              key: ValueKey('social-$index'),
              index: index,
              social: resume.socials![index],
            ),
        onPrevious: () => setState(() => _currentSocialIndex--),
        onNext: () => setState(() => _currentSocialIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addSocial(Social());
          setState(() {
            _currentSocialIndex = (resume.socials?.length ?? 0);
          });
        },
        onRemove: () {
          ref
              .read(localResumeProvider.notifier)
              .removeSocial(_currentSocialIndex);
          setState(() {
            _currentSocialIndex = (_currentSocialIndex - 1).clamp(0, 100);
          });
        },
      ),

      // 6. Projetos
      _buildFocusedEditorTab(
        context: context,
        resume: resume,
        itemLabel: 'Projeto',
        currentIndex: _currentProjectIndex,
        totalItems: resume.projects?.length ?? 0,
        formBuilder:
            (index) => ProjectForm(
              key: ValueKey('project-$index'),
              index: index,
              project: resume.projects![index],
            ),
        onPrevious: () => setState(() => _currentProjectIndex--),
        onNext: () => setState(() => _currentProjectIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addProject(Project());
          setState(() {
            _currentProjectIndex = (resume.projects?.length ?? 0);
          });
        },
        onRemove: () {
          ref
              .read(localResumeProvider.notifier)
              .removeProject(_currentProjectIndex);
          setState(() {
            _currentProjectIndex = (_currentProjectIndex - 1).clamp(0, 100);
          });
        },
      ),

      // 7. Certificados
      _buildFocusedEditorTab(
        context: context,
        resume: resume,
        itemLabel: 'Certificado',
        currentIndex: _currentCertificateIndex,
        totalItems: resume.certificates?.length ?? 0,
        formBuilder:
            (index) => CertificateForm(
              key: ValueKey('certificate-$index'),
              index: index,
              certificate: resume.certificates![index],
            ),
        onPrevious: () => setState(() => _currentCertificateIndex--),
        onNext: () => setState(() => _currentCertificateIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addCertificate(Certificate());
          setState(() {
            _currentCertificateIndex = (resume.certificates?.length ?? 0);
          });
        },
        onRemove: () {
          ref
              .read(localResumeProvider.notifier)
              .removeCertificate(_currentCertificateIndex);
          setState(() {
            _currentCertificateIndex = (_currentCertificateIndex - 1).clamp(
              0,
              100,
            );
          });
        },
      ),

      // 8. Acessibilidade
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Configurações de Acessibilidade', context),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Incluir informações de PCD no currículo'),
              subtitle: const Text(
                'Selecione para incluir as informações de deficiência do seu perfil no currículo.',
              ),
              value: resume.includePCDInfo,
              onChanged: (value) {
                ref
                    .read(localResumeProvider.notifier)
                    .toggleIncludePCDInfo(value ?? false);
              },
            ),
          ],
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Center(
              child: Text(
                'Preencha seu currículo',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TabBar(controller: _tabController, isScrollable: true, tabs: _tabs),
        Expanded(
          child: TabBarView(controller: _tabController, children: tabViews),
        ),
      ],
    );
  }

  // Helper widget to build the focused editor UI for any section
  Widget _buildFocusedEditorTab({
    required BuildContext context,
    required resume,
    required String itemLabel,
    required int currentIndex,
    required int totalItems,
    required Widget Function(int) formBuilder,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            '$itemLabel${itemLabel.endsWith('l') ? 's' : 's'}',
            context,
          ),
          if (totalItems > 0)
            _buildFocusedEditorControls(
              currentIndex: currentIndex,
              totalItems: totalItems,
              itemLabel: itemLabel,
              onPrevious: onPrevious,
              onNext: onNext,
            ),
          const SizedBox(height: 16),
          if (totalItems > 0)
            formBuilder(currentIndex)
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: Text(
                  'Nenhum${itemLabel.endsWith('a') ? 'a' : ''} $itemLabel adicionad${itemLabel.endsWith('a') ? 'a' : 'o'}.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(
                  'Adicionar Nov${itemLabel.endsWith('a') ? 'a' : 'o'}',
                ),
                onPressed: onAdd,
              ),
              if (totalItems > 0)
                TextButton.icon(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: Text(
                    'Remover Atu${itemLabel.endsWith('a') ? 'al' : 'al'}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onPressed: onRemove,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
