import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';

class LoadUserProfileUseCase {
  final UserProfileRepository _repository;

  LoadUserProfileUseCase(this._repository);

  Future<UserProfile?> call(String userId) {
    return _repository.loadProfile(userId);
  }
}
