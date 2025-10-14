import 'package:intelliresume/data/models/cv_model.dart';
import 'package:intelliresume/domain/repositories/resume_repository.dart';

class GetResumeByIdUsecase {
  final ResumeRepository repository;

  GetResumeByIdUsecase(this.repository);

  Future<CVModel> call(String userId, String resumeId) {
    return repository.getResumeById(userId, resumeId);
  }
}
