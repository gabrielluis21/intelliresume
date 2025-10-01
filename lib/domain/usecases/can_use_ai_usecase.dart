import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';

class CanUseAIUseCase {
  final UserProfileRepository _userProfileRepository;

  CanUseAIUseCase(this._userProfileRepository);

  Future<bool> call({
    required String userId,
    required int currentAiInteractions,
  }) async {
    final UserProfile? profile = await _userProfileRepository.loadProfile(
      userId,
    );
    final plan = profile?.plan ?? PlanType.free;

    if (plan == PlanType.free) {
      return currentAiInteractions < 3;
    }

    // Premium e Pro têm uso ilimitado
    return true;
  }
}
