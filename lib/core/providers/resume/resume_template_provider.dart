import 'package:flutter_riverpod/legacy.dart';
import 'package:intelliresume/core/providers/domain_providers.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/core/templates/resume_template.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:riverpod/riverpod.dart';

/// Provider que filtra os templates disponíveis de forma assíncrona, baseado no plano do usuário.
final availableTemplatesProvider = FutureProvider<List<ResumeTemplate>>((
  ref,
) async {
  final canUseTemplate = ref.watch(canUseTemplateUseCaseProvider);
  final userId = ref.watch(userProfileProvider).value?.uid;

  if (userId == null) {
    // Se o usuário não está logado, mostramos apenas os templates gratuitos.
    const freeTemplatesIds = <String>{
      'intelliresume_pattern',
      'classic',
      'studant_first_job',
    };
    return ResumeTemplate.allTemplates
        .where((t) => freeTemplatesIds.contains(t.id))
        .toList();
  }

  final List<ResumeTemplate> filteredTemplates = [];
  for (final template in ResumeTemplate.allTemplates) {
    if (await canUseTemplate(userId: userId, templateId: template.id)) {
      filteredTemplates.add(template);
    }
  }
  return filteredTemplates;
});

final selectedTemplateIndexProvider = StateProvider<int>((ref) => 0);

/// Provider com o template selecionado atualmente.
/// A UI será responsável por definir o valor inicial quando a lista do FutureProvider carregar.
final selectedTemplateProvider = StateProvider<ResumeTemplate?>((ref) {
  return null;
});

final resumeDataProvider = Provider<ResumeData>((ref) {
  // Mock data, pode permanecer como está por enquanto.
  return ResumeData(
    personalInfo: UserProfile(
      email: '',
      name: '',
      phone: '',
      profilePictureUrl: '',
    ),
    about: '',
    objective: '',
    experiences: [],
    educations: [],
    skills: [],
    socials: [],
    projects: [],
  );
});
