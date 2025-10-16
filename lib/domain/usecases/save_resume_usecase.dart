import 'package:intelliresume/data/models/cv_model.dart';
import 'package:intelliresume/domain/repositories/resume_repository.dart';

class SaveResumeUseCase {
  final ResumeRepository repository;
  SaveResumeUseCase(this.repository);

  Future<void> call(String userId, CVModel resume) {
    return repository.saveResume(userId, resume);
  }
}
