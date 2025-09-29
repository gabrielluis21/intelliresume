import 'package:intelliresume/core/templates/resume_template.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:riverpod/riverpod.dart';

/// Provider que expõe templates disponíveis conforme o plano do usuário
final availableTemplatesProvider = Provider<List<ResumeTemplate>>((ref) {
  // Obtém plano e filtra
  return ResumeTemplate.allTemplates;
});

final selectedTemplateIndexProvider = StateProvider<int>((ref) => 0);

/// Provider com o template selecionado atualmente
final selectedTemplateProvider = StateProvider<ResumeTemplate?>((ref) {
  final list = ref.watch(availableTemplatesProvider);
  return list.isNotEmpty ? list.first : null;
});

final resumeDataProvider = Provider<ResumeData>((ref) {
  // Aqui você preenche com os dados vindos do Firebase ou formulário
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
