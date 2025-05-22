import 'package:flutter/foundation.dart';
import '../datasources/local/resume_local_ds.dart';
import '../datasources/remote/remote_resume_ds.dart';

abstract class ResumeRepository {
  Future<void> save(String userId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> load(String userId);
}

class ResumeRepositoryImpl implements ResumeRepository {
  final LocalResumeDataSource local;
  final RemoteResumeDataSource remote;

  ResumeRepositoryImpl({required this.local, required this.remote});

  @override
  Future<void> save(String userId, Map<String, dynamic> data) async {
    await local.cacheResume(userId, data);
    try {
      await remote.saveResume(userId, data);
    } catch (_) {
      // falha silenciosa, já está em cache
    }
  }

  @override
  Future<Map<String, dynamic>?> load(String userId) async {
    if (kIsWeb) {
      final r = await remote.fetchResume(userId);
      if (r != null) {
        await local.cacheResume(userId, r);
        return r;
      }
      return await local.getCachedResume(userId);
    } else {
      final l = await local.getCachedResume(userId);
      if (l != null) return l;
      final r = await remote.fetchResume(userId);
      if (r != null) {
        await local.cacheResume(userId, r);
        return r;
      }
      return null;
    }
  }
}
