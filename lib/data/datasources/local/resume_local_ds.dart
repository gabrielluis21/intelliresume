// lib/data/datasources/local/resume_local_ds.dart

import 'package:hive/hive.dart';

abstract class LocalResumeDataSource {
  Future<void> cacheResume(String userId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getCachedResume(String userId);
}

class HiveResumeDataSource implements LocalResumeDataSource {
  static const _boxName = 'resumes';

  @override
  Future<void> cacheResume(String userId, Map<String, dynamic> data) async {
    final box = await Hive.openBox(_boxName);
    await box.put(userId, data);
  }

  @override
  Future<Map<String, dynamic>?> getCachedResume(String userId) async {
    final box = await Hive.openBox(_boxName);
    return box.get(userId)?.cast<String, dynamic>();
  }
}
