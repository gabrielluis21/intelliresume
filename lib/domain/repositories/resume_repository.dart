import 'package:intelliresume/data/models/cv_model.dart';

abstract class ResumeRepository {
  Stream<List<CVModel>> getResumes(String userId);
  Future<CVModel> getResumeById(String userId, String resumeId);
  Future<void> saveResume(String userId, CVModel resume);
}
