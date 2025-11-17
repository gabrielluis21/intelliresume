import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/resume/cv_provider.dart';
import 'package:intelliresume/core/providers/editor/editor_providers.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/di.dart';
import 'package:intelliresume/generated/app_localizations.dart';
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
  final AppLocalizations translate;
  const ResumeForm({super.key, this.resume, required this.translate});

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

  //late AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //l10n = AppLocalizations.of(context)!;
  }

  late final _tabs = <Widget>[
    Tab(
      icon: const Icon(Icons.person_search_outlined),
      text: widget.translate.resumeForm_aboutMeTab,
    ),
    Tab(
      icon: const Icon(Icons.person_search_outlined),
      text: widget.translate.resumeForm_objectiveTab,
    ),
    Tab(
      icon: const Icon(Icons.work_outline),
      text: widget.translate.resumeForm_experienceTab,
    ),
    Tab(
      icon: const Icon(Icons.school_outlined),
      text: widget.translate.resumeForm_educationTab,
    ),
    Tab(
      icon: const Icon(Icons.lightbulb_outline),
      text: widget.translate.resumeForm_skillsTab,
    ),
    Tab(
      icon: const Icon(Icons.link_outlined),
      text: widget.translate.resumeForm_socialTab,
    ),
    Tab(
      icon: const Icon(Icons.folder_outlined),
      text: widget.translate.resumeForm_projectsTab,
    ),
    Tab(
      icon: const Icon(Icons.badge_outlined),
      text: widget.translate.resumeForm_certificatesTab,
    ),
    Tab(
      icon: const Icon(Icons.accessibility_new_outlined),
      text: widget.translate.resumeForm_accessibilityTab,
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

  Future<void> _importFromLinkedIn() async {
    // TODO: Add loading state
    try {
      final profile =
          await ref.read(importLinkedInProfileUseCaseProvider).call();
      ref.read(localResumeProvider.notifier).updateFromLinkedInProfile(profile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados importados com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao importar dados: ${e.toString()}')),
      );
    }
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
          tooltip: widget.translate.resumeForm_previous,
        ),
        Text(
          widget.translate.resumeForm_itemCount(
            (currentIndex + 1).toString(),
            itemLabel,
            totalItems.toString(),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: currentIndex < totalItems - 1 ? onNext : null,
          tooltip: widget.translate.resumeForm_next,
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
            _buildSectionHeader(
              widget.translate.resumeForm_aboutMeTab,
              context,
            ),
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
            _buildSectionHeader(
              widget.translate.resumeForm_professionalObjective,
              context,
            ),
            ObjectiveForm(objective: resume.objective ?? ''),
          ],
        ),
      ),
      // 2. Experiências
      _buildFocusedEditorTab(
        context: context,
        resume: resume,
        itemLabel: widget.translate.resumeForm_experienceTab,
        currentIndex: _currentExperienceIndex,
        totalItems: resume.experiences.length,
        formBuilder:
            (index) => ExperienceForm(
              key: ValueKey('exp-$index'),
              index: index,
              experience: resume.experiences[index],
            ),
        onPrevious: () => setState(() => _currentExperienceIndex--),
        onNext: () => setState(() => _currentExperienceIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addExperience(Experience());
          setState(() {
            _currentExperienceIndex = (resume.experiences.length);
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
        itemLabel: widget.translate.resumeForm_educationTab,
        currentIndex: _currentEducationIndex,
        totalItems: resume.educations.length,
        formBuilder:
            (index) => EducationForm(
              key: ValueKey('edu-${(index + 1)}'),
              index: index,
              education: resume.educations[index],
            ),
        onPrevious: () => setState(() => _currentEducationIndex--),
        onNext: () => setState(() => _currentEducationIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addEducation(Education());
          setState(() {
            _currentEducationIndex = (resume.educations.length);
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
        itemLabel: widget.translate.resumeForm_skillsTab,
        currentIndex: _currentSkillIndex,
        totalItems: resume.skills.length,
        formBuilder:
            (index) => SkillForm(
              key: ValueKey('skill-$index'),
              index: index,
              skill: resume.skills[index],
            ),
        onPrevious: () => setState(() => _currentSkillIndex--),
        onNext: () => setState(() => _currentSkillIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addSkill(Skill());
          setState(() {
            _currentSkillIndex = (resume.skills.length);
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
        itemLabel: widget.translate.resumeForm_socialTab,
        currentIndex: _currentSocialIndex,
        totalItems: resume.socials.length,
        formBuilder:
            (index) => SocialForm(
              key: ValueKey('social-$index'),
              index: index,
              social: resume.socials[index],
            ),
        onPrevious: () => setState(() => _currentSocialIndex--),
        onNext: () => setState(() => _currentSocialIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addSocial(Social());
          setState(() {
            _currentSocialIndex = (resume.socials.length);
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
        itemLabel: widget.translate.resumeForm_projectsTab,
        currentIndex: _currentProjectIndex,
        totalItems: resume.projects.length,
        formBuilder:
            (index) => ProjectForm(
              key: ValueKey('project-$index'),
              index: index,
              project: resume.projects[index],
            ),
        onPrevious: () => setState(() => _currentProjectIndex--),
        onNext: () => setState(() => _currentProjectIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addProject(Project());
          setState(() {
            _currentProjectIndex = (resume.projects.length);
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
        itemLabel: widget.translate.resumeForm_certificatesTab,
        currentIndex: _currentCertificateIndex,
        totalItems: resume.certificates.length,
        formBuilder:
            (index) => CertificateForm(
              key: ValueKey('certificate-$index'),
              index: index,
              certificate: resume.certificates[index],
            ),
        onPrevious: () => setState(() => _currentCertificateIndex--),
        onNext: () => setState(() => _currentCertificateIndex++),
        onAdd: () {
          ref.read(localResumeProvider.notifier).addCertificate(Certificate());
          setState(() {
            _currentCertificateIndex = (resume.certificates.length);
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
            _buildSectionHeader(
              widget.translate.resumeForm_accessibilitySettings,
              context,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(widget.translate.resumeForm_includePCDInfo),
              subtitle: Text(
                widget.translate.resumeForm_includePCDInfoSubtitle,
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
                widget.translate.resumeForm_fillYourResume,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.cloud_download), // Placeholder icon
            label: const Text('Importar do LinkedIn'),
            onPressed: _importFromLinkedIn,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
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
          _buildSectionHeader(itemLabel, context),
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
                  widget.translate.resumeForm_noItemAdded(itemLabel),
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
                label: Text(widget.translate.resumeForm_add(itemLabel)),
                onPressed: onAdd,
              ),
              if (totalItems > 0)
                TextButton.icon(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: Text(
                    widget.translate.resumeForm_removeCurrent(itemLabel),
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
