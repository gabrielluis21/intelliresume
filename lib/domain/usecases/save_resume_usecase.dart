// lib/domain/usecases/save_resume_usecase.dart

import '../../data/repositories/resume_repository.dart';

class SaveResumeUseCase {
  final ResumeRepository repository;
  SaveResumeUseCase(this.repository);

  Future<void> call(String userId, Map<String, dynamic> data) {
    // Aqui você pode adicionar validações de negócio, limites de plano etc.
    return repository.save(userId, data);
  }
}
