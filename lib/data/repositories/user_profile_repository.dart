// lib/data/repositories/user_profile_repository.dart

import '../datasources/remote/remote_user_profile_ds.dart';
import '../datasources/local/local_user_profile_ds.dart';
import '../../domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> loadProfile(String uid);
  Future<void> saveProfile(UserProfile profile);
}

class UserProfileRepositoryImpl implements UserProfileRepository {
  final RemoteUserProfileDataSource remote;
  final LocalUserProfileDataSource local;
  UserProfileRepositoryImpl({required this.remote, required this.local});

  @override
  Future<UserProfile?> loadProfile(String uid) async {
    // tenta remoto, se falha, carrega local
    final rem = await remote.fetchProfile(uid);
    if (rem != null) {
      await local.saveProfile(rem.uid, rem.toJson());
      return rem;
    }
    final loc = await local.fetchProfile(uid);
    if (loc != null) {
      return UserProfile.fromJson(loc);
    }
    return null;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await local.saveProfile(profile.uid, profile.toJson());
    await remote.saveProfile(profile);
  }
}
