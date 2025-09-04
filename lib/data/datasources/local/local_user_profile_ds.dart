import 'package:hive/hive.dart';

import '../../../domain/entities/user_profile.dart';

abstract class LocalUserProfileDataSource {
  Future<void> saveProfile(String uid, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> fetchProfile(String uid);
  Stream<UserProfile> watchProfile(String uid);
  Future<void> deleteProfile(String uid);
}

class HiveUserProfileDataSource implements LocalUserProfileDataSource {
  static const _boxName = 'user_profiles';

  @override
  Future<void> saveProfile(String uid, Map<String, dynamic> data) async {
    final box = await Hive.openBox(_boxName);
    await box.put(uid, data);
  }

  @override
  Future<Map<String, dynamic>?> fetchProfile(String uid) async {
    final box = await Hive.openBox(_boxName);
    return box.get(uid)?.cast<String, dynamic>();
  }

  @override
  Stream<UserProfile> watchProfile(String uid) async* {
    // Emite o valor atual imediatamente
    final data = await Hive.openBox(_boxName);
    final profile = data.get(uid)?.cast<String, dynamic>();
    if (profile != null) {
      yield profile;
    }

    // Observa futuras mudanças
    yield* data
        .watch(key: uid)
        .map((event) {
          return event.value as UserProfile?;
        })
        .where((profile) => profile != null)
        .cast<UserProfile>();
  }

  @override
  Future<void> deleteProfile(String uid) async {
    final box = await Hive.openBox(_boxName);
    await box.delete(uid);
  }
}
