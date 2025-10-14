import 'package:intelliresume/data/models/cv_model.dart';
import 'package:intelliresume/domain/repositories/resume_repository.dart';

class GetResumesUsecase {
  final ResumeRepository repository;

  GetResumesUsecase(this.repository);

  Stream<List<CVModel>> call(String userId) {
    return repository.getResumes(userId);
  }
}
