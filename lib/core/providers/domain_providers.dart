import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/data/data_provider.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/domain/usecases/can_use_ai_usecase.dart';
import 'package:intelliresume/domain/usecases/can_use_template_usecase.dart';
import 'package:intelliresume/domain/usecases/save_resume_usecase.dart'; // NOVA IMPORTAÇÃO
import 'package:intelliresume/domain/usecases/save_user_usecaase.dart';
import 'package:intelliresume/domain/usecases/update_plan_usecase.dart';
import 'package:intelliresume/domain/usecases/load_user_profile_usecase.dart';

// --- Use Case Providers ---

final saveResumeUseCaseProvider = Provider<SaveResumeUseCase>((ref) {
  final repository = ref.watch(resumeRepositoryProvider);
  return SaveResumeUseCase(repository);
});

final updatePlanUseCaseProvider = Provider<UpdatePlanUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UpdatePlanUseCase(repository);
});

final canUseTemplateUseCaseProvider = Provider<CanUseTemplateUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return CanUseTemplateUseCase(repository);
});

final canUseAIUseCaseProvider = Provider<CanUseAIUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return CanUseAIUseCase(repository);
});

// NOVO PROVIDER ADICIONADO
final saveUserProfileUseCaseProvider = Provider<SaveUserProfileUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return SaveUserProfileUseCase(repository);
});

final loadUserProfileUseCaseProvider = Provider<LoadUserProfileUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return LoadUserProfileUseCase(repository);
});

final canUseTemplateProviderFamily = FutureProvider.family<bool, String>((
  ref,
  templateId,
) async {
  final useCase = ref.watch(canUseTemplateUseCaseProvider);
  final userId = ref.watch(userProfileProvider).value?.uid;

  return useCase(userId: userId ?? 'logged_out_user', templateId: templateId);
});
