import 'package:hive/hive.dart';

abstract class LocalUserProfileDataSource {
  Future<void> saveProfile(String uid, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> fetchProfile(String uid);
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
}
