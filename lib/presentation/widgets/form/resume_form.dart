import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/cv_provider.dart';
import 'package:intelliresume/core/providers/editor_providers.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/presentation/widgets/form/widgets/objective_form.dart';

import 'widgets/education_form.dart';
import 'widgets/experience_form.dart';
import 'widgets/skill_form.dart';
import 'widgets/social_form.dart';

class ResumeForm extends ConsumerStatefulWidget {
  const ResumeForm({super.key});

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

  final _tabs = <Widget>[
    const Tab(icon: Icon(Icons.person_search_outlined), text: 'Objetivo'),
    const Tab(icon: Icon(Icons.work_outline), text: 'Experiência'),
    const Tab(icon: Icon(Icons.school_outlined), text: 'Educação'),
    const Tab(icon: Icon(Icons.lightbulb_outline), text: 'Habilidades'),
    const Tab(icon: Icon(Icons.link_outlined), text: 'Social'),
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
      ref.read(localResumeProvider.notifier).initialize(ResumeData.initial());
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
      // 1. Objetivo
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
          ref
              .read(localResumeProvider.notifier)
              .addExperience(resume.experiences![_currentExperienceIndex]);
          setState(() {
            _currentExperienceIndex = resume.experiences!.length;
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
              key: ValueKey('edu-$index'),
              index: index,
              education: resume.educations![index],
            ),
        onPrevious: () => setState(() => _currentEducationIndex--),
        onNext: () => setState(() => _currentEducationIndex++),
        onAdd: () {
          ref
              .read(localResumeProvider.notifier)
              .addEducation(resume.educations![_currentEducationIndex]);
          setState(() {
            _currentEducationIndex = resume.educations!.length;
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
          ref
              .read(localResumeProvider.notifier)
              .addSkill(resume.skills![_currentSkillIndex]);
          setState(() {
            _currentSkillIndex = resume.skills!.length;
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
          ref
              .read(localResumeProvider.notifier)
              .addSocial(resume.socials![_currentSocialIndex]);
          setState(() {
            _currentSocialIndex = resume.socials!.length;
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

      // 6. Acessibilidade
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
          _buildFocusedEditorControls(
            currentIndex: currentIndex,
            totalItems: totalItems,
            itemLabel: itemLabel,
            onPrevious: onPrevious,
            onNext: onNext,
          ),
          const SizedBox(height: 16),
          if (totalItems > 0) formBuilder(currentIndex),
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
