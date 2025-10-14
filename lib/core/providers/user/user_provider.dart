import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/data/data_provider.dart';
import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';

// Provider para o stream de mudanças de autenticação
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final getAuthStateChanges = ref.watch(getAuthStateChangesUseCaseProvider);
  return getAuthStateChanges();
});

// Provider para o perfil do usuário, agora reativo às mudanças de autenticação
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
      final userProfileRepository = ref.watch(userProfileRepositoryProvider);
      // Ouve o provider de autenticação
      final authState = ref.watch(authStateChangesProvider);

      return UserProfileNotifier(userProfileRepository, authState.valueOrNull);
    });

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserProfileRepository _repository;
  final User? _user;
  StreamSubscription? _profileSubscription;

  UserProfileNotifier(this._repository, this._user)
    : super(const AsyncLoading()) {
    _init();
  }

  void _init() {
    if (_user == null) {
      state = const AsyncData(null);
      return;
    }
    _profileSubscription = _repository
        .watchProfile(_user.uid)
        .listen(
          (profile) {
            state = AsyncData(profile);
          },
          onError: (error, stackTrace) {
            state = AsyncError(error, stackTrace);
          },
        );
  }

  // Atualiza o perfil localmente e remotamente
  Future<void> updateUser(UserProfile updatedProfile) async {
    final currentUser = state.value;
    if (currentUser == null) return; // Não faz nada se não houver usuário

    state = const AsyncLoading();
    try {
      await _repository.saveProfile(updatedProfile);
      // O stream já irá notificar o estado com o novo perfil,
      // então não precisamos atualizar manualmente aqui.
    } catch (e, st) {
      state = AsyncError(e, st);
      // Se der erro, volta ao estado anterior para manter a UI consistente
      state = AsyncData(currentUser);
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
    _profileSubscription?.cancel();
    super.dispose();
  }

  bool get isPremium => state.value?.plan == PlanType.premium;
  bool get isLoggedIn => state.value != null;
}
