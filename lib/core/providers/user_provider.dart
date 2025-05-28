import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../domain/entities/user_profile.dart';

// Suponha que esse repositório seja inicializado em outro lugar (ex: via ProviderScope)
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  throw UnimplementedError(); // fornecido em outro lugar
});

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
      final repository = ref.watch(userProfileRepositoryProvider);
      return UserProfileNotifier(repository);
    });

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final UserProfileRepository _repository;

  UserProfileNotifier(this._repository) : super(null);

  Future<void> loadUser(String uid) async {
    final profile = await _repository.loadProfile(uid);
    state = profile;
  }

  Future<void> updateUser(UserProfile updatedProfile) async {
    await _repository.saveProfile(updatedProfile);
    state = updatedProfile;
  }

  bool get isPremium => state?.plan == PlanType.premium;
  bool get isLogedIn => state != null;
}
