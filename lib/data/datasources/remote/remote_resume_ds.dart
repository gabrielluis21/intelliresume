// lib/data/datasources/remote/remote_resume_ds.dart

/// Interface que define métodos de persistência remota de Currículo.
abstract class RemoteResumeDataSource {
  Future<void> saveResume(String userId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> fetchResume(String userId);
}
