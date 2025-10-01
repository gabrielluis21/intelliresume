import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';

class CanUseTemplateUseCase {
  final UserProfileRepository _userProfileRepository;

  CanUseTemplateUseCase(this._userProfileRepository);

  // Templates disponíveis por plano
  static const _freeTemplates = <String>{
    'intelliresume_pattern',
    'classic',
    'studant_first_job',
  };
  static const _paidTemplates = <String>{
    'modern_with_sidebar',
    'timeline',
    'infographic',
    'international',
    'dev_tec',
  };
  // static const _proTemplates = <String>{
  //   // 'pro_exclusive_template'
  // };

  Future<bool> call({
    required String userId,
    required String templateId,
  }) async {
    // Em vez de depender de um provider da UI, ele busca os dados frescos do repositório.
    final UserProfile? profile = await _userProfileRepository.loadProfile(
      userId,
    );
    final plan = profile?.plan ?? PlanType.free;

    if (plan == PlanType.free) {
      return _freeTemplates.contains(templateId);
    }
    if (plan == PlanType.premium) {
      return _freeTemplates.contains(templateId) ||
          _paidTemplates.contains(templateId);
    }
    if (plan == PlanType.pro) {
      return true; // Pro pode usar todos
    }
    return false;
  }
}
