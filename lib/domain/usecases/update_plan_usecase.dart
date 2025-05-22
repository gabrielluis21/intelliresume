// lib/domain/usecases/update_plan_usecase.dart

import '../../data/repositories/user_profile_repository.dart';
import '../../data/datasources/remote/remote_user_profile_ds.dart';
import '../../data/datasources/local/local_user_profile_ds.dart';
import '../entities/user_profile.dart';

class UpdatePlanUseCase {
  final UserProfileRepository _repo = UserProfileRepositoryImpl(
    remote: RemoteUserProfileDataSource(),
    local: HiveUserProfileDataSource(),
  );

  Future<UserProfile> call(String uid, PlanType newPlan) async {
    final profile = await _repo.loadProfile(uid);
    final updated = profile!.copyWith(plan: newPlan);
    await _repo.saveProfile(updated);
    return updated;
  }
}
