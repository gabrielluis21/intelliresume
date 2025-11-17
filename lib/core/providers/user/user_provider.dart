import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intelliresume/core/providers/data/data_provider.dart';
import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';

// Original provider for auth state as AsyncValue
final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final getAuthStateChanges = ref.watch(getAuthStateChangesUseCaseProvider);
  return getAuthStateChanges();
});

// New provider that just exposes the raw stream to work around a compiler bug
final authStreamProvider = Provider<Stream<User?>>((ref) {
  final getAuthStateChanges = ref.watch(getAuthStateChangesUseCaseProvider);
  return getAuthStateChanges();
});

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
      final userProfileRepository = ref.watch(userProfileRepositoryProvider);
      // Watch the new, simple stream provider
      final authStream = ref.watch(authStreamProvider);

      final notifier = UserProfileNotifier(userProfileRepository);
      notifier.init(authStream);

      return notifier;
    });

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserProfileRepository _repository;
  StreamSubscription? _authSubscription;
  StreamSubscription? _profileSubscription;

  UserProfileNotifier(this._repository) : super(const AsyncValue.loading());

  void init(Stream<User?> authStream) {
    _authSubscription = authStream.listen((user) {
      _profileSubscription?.cancel();
      if (user == null) {
        state = const AsyncValue.data(null);
      } else {
        state = const AsyncValue.loading();
        _profileSubscription = _repository
            .watchProfile(user.uid)
            .listen(
              (profile) => state = AsyncValue.data(profile),
              onError: (e, st) => state = AsyncValue.error(e, st),
            );
      }
    });
  }

  Future<void> updateUser(UserProfile updatedProfile) async {
    final originalState = state;
    state = const AsyncValue.loading();
    try {
      await _repository.saveProfile(updatedProfile);
      state = AsyncValue.data(updatedProfile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      Future.delayed(const Duration(seconds: 2), () => state = originalState);
      rethrow;
    }
  }

  Future<void> updateProfilePicture(String photoUrl) async {
    final current = state.value;
    if (current == null) return;
    final updatedProfile = current.copyWith(profilePictureUrl: photoUrl);
    await updateUser(updatedProfile);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    super.dispose();
  }

  bool get isPremium => state.value?.plan == PlanType.premium;
  bool get isLoggedIn => state.value != null;
}
