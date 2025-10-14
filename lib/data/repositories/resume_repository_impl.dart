import 'package:intelliresume/data/datasources/resume_remote_datasource.dart';
import 'package:intelliresume/data/models/cv_model.dart';
import 'package:intelliresume/domain/repositories/resume_repository.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final ResumeRemoteDataSource remoteDataSource;

  ResumeRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<CVModel>> getResumes(String userId) {
    return remoteDataSource.getResumes(userId);
  }

  @override
  Future<CVModel> getResumeById(String userId, String resumeId) {
    return remoteDataSource.getResumeById(userId, resumeId);
  }

  @override
  Future<void> saveResume(String userId, CVModel resume) {
    return remoteDataSource.saveResume(userId, resume);
  }
}
