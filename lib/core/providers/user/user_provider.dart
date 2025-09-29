import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/data/datasources/local/local_user_profile_ds.dart';
import 'package:intelliresume/data/datasources/remote/remote_user_profile_ds.dart';
import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Provider para a instância do FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// Provider para o repositório
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final local = HiveUserProfileDataSource();
  final remote = RemoteUserProfileDataSource();
  return UserProfileRepositoryImpl(remote: remote, local: local);
});

// Provider para o perfil do usuário
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return UserProfileNotifier(repository, auth);
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserProfileRepository _repository;
  final FirebaseAuth _auth;
  StreamSubscription? _subscription;

  UserProfileNotifier(this._repository, this._auth) : super(const AsyncLoading()) {
    _init();
  }

  Future<void> _init() async {
    final user = _auth.currentUser;
    if (user == null) {
      state = const AsyncData(null);
      return;
    }

    // Tenta carregar do cache primeiro
    try {
      final cachedProfile = await _repository.getCachedProfile(user.uid);
      if (cachedProfile != null) {
        state = AsyncData(cachedProfile);
      }
    } catch (_) {}

    // Inicia stream de atualizações em tempo real
    _subscription = _repository
        .watchProfile(user.uid)
        .listen(
          (profile) {
            state = AsyncData(profile);
          },
          onError: (error, stackTrace) {
            state = AsyncError(error, stackTrace);
          },
        );
  }

  // Carrega e atualiza o perfil
  Future<void> loadUser(String uid) async {
    state = const AsyncLoading();
    try {
      final profile = await _repository.loadProfile(uid);
      state = AsyncData(profile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Atualiza o perfil localmente e remotamente
  Future<void> updateUser(UserProfile updatedProfile) async {
    try {
      state = const AsyncLoading();
      await _repository.saveProfile(updatedProfile);

      // Atualiza apenas os campos modificados
      state = state.whenData(
        (current) => current?.copyWith(
          name: updatedProfile.name,
          email: updatedProfile.email,
          phone: updatedProfile.phone,
          profilePictureUrl: updatedProfile.profilePictureUrl,
          plan: updatedProfile.plan,
          pcdInfo: updatedProfile.pcdInfo,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  // Atualiza apenas a foto de perfil
  Future<void> updateProfilePicture(String photoUrl) async {
    final current = state.value;
    if (current == null) return;

    final updatedProfile = current.copyWith(profilePictureUrl: photoUrl);
    await updateUser(updatedProfile);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  bool get isPremium => state.value?.plan == PlanType.premium;
  bool get isLoggedIn => state.value != null;
}
