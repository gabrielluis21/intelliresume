// lib/domain/usecases/update_plan_usecase.dart

import 'package:intelliresume/domain/entities/plan_type.dart';

import '../../data/repositories/user_profile_repository.dart';
import '../entities/user_profile.dart';

class UpdatePlanUseCase {
  final UserProfileRepository _repo;

  UpdatePlanUseCase(this._repo);

  Future<UserProfile> call(String uid, PlanType newPlan) async {
    final profile = await _repo.loadProfile(uid);
    final updated = profile!.copyWith(plan: newPlan);
    await _repo.saveProfile(updated);
    return updated;
  }
}
