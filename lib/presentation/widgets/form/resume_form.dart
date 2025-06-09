import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/cv_provider.dart';
import 'widgets/education_form.dart';
import 'widgets/experience_form.dart';
import 'widgets/form_section.dart';
import 'widgets/skill_form.dart';
import 'widgets/social_form.dart';

class ResumeForm extends ConsumerWidget {
  const ResumeForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(resumeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Adicione um título geral
          const Text(
            'Preencha seu currículo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Seção de Experiências
          _buildSection(
            title: 'Experiências Profissionais',
            onAdd: () => ref.read(resumeProvider.notifier).addExperience(),
            children:
                resume.experiences!.asMap().entries.map((entry) {
                  final index = entry.key;
                  return ExperienceForm(
                    key: ValueKey('exp-$index-${entry.value.hashCode}'),
                    index: index,
                    experience: entry.value,
                  );
                }).toList(),
          ),

          // Seção de Educação
          _buildSection(
            title: 'Formação Acadêmica',
            onAdd: () => ref.read(resumeProvider.notifier).addEducation(),
            children:
                resume.educations!.asMap().entries.map((entry) {
                  final index = entry.key;
                  return EducationForm(
                    key: ValueKey('edu-$index-${entry.value.hashCode}'),
                    index: index,
                    education: entry.value,
                  );
                }).toList(),
          ),

          // Seção de Habilidades
          _buildSection(
            title: 'Habilidades',
            onAdd: () => ref.read(resumeProvider.notifier).addSkill(),
            children:
                resume.skills!.asMap().entries.map((entry) {
                  final index = entry.key;
                  return SkillForm(
                    key: ValueKey('skill-$index-${entry.value.hashCode}'),
                    index: index,
                    skill: entry.value,
                  );
                }).toList(),
          ),

          // Seção de Redes Sociais
          _buildSection(
            title: 'Redes Sociais',
            onAdd: () => ref.read(resumeProvider.notifier).addSocial(),
            children:
                resume.socials!.asMap().entries.map((entry) {
                  final index = entry.key;
                  return SocialForm(
                    key: ValueKey('social-$index-${entry.value.hashCode}'),
                    index: index,
                    social: entry.value,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required VoidCallback onAdd,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar'),
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
