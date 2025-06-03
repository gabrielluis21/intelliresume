// lib/data/repositories/user_profile_repository.dart

import '../datasources/remote/remote_user_profile_ds.dart';
import '../datasources/local/local_user_profile_ds.dart';
import '../../domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> loadProfile(String uid);
  Future<void> saveProfile(UserProfile profile);
  Future<void> deleteProfile(String uid); // opcional, se necessário
  Future<void> verifyProfileEmail(); // opcional, se necessário
  Future<void> updateProfile(UserProfile profile); // opcional, se necessário
  Stream<UserProfile> watchProfile(String uid);
  Future<UserProfile?> getCachedProfile(String uid);
}

class UserProfileRepositoryImpl implements UserProfileRepository {
  final RemoteUserProfileDataSource remote;
  final LocalUserProfileDataSource local;

  UserProfileRepositoryImpl({required this.remote, required this.local});

  @override
  Future<UserProfile> loadProfile(String uid) async {
    try {
      // Tenta carregar remotamente
      final profile = await remote.fetchProfile(uid);
      await local.saveProfile(profile!.uid!, profile.toJson());
      return profile;
    } catch (e) {
      // Fallback para cache local se a rede falhar
      final cached = await local.fetchProfile(uid);
      if (cached != null) return UserProfile.fromJson(cached);
      rethrow;
    }
  }

  @override
  Stream<UserProfile> watchProfile(String uid) {
    return remote.watchProfile(uid).asyncMap((profile) async {
      await local.saveProfile(profile.uid!, profile.toJson());
      return profile;
    });
  }

  @override
  Future<UserProfile?> getCachedProfile(String uid) async {
    final data = await local.fetchProfile(uid);
    return data != null ? UserProfile.fromJson(data) : null;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    // Salva remotamente e atualiza cache local
    await remote.saveProfile(profile);
    await local.saveProfile(profile.uid!, profile.toJson());
  }

  @override
  Future<void> deleteProfile(String uid) {
    // TODO: implement deleteProfile
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile(UserProfile profile) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<void> verifyProfileEmail() {
    // TODO: implement verifyProfileEmail
    throw UnimplementedError();
  }
}
