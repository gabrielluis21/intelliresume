import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/data/datasources/resume_remote_datasource.dart';
import 'package:intelliresume/data/repositories/resume_repository_impl.dart';
import 'package:intelliresume/domain/repositories/resume_repository.dart';
import 'package:intelliresume/domain/usecases/get_resume_by_id_usecase.dart';
import 'package:intelliresume/domain/usecases/get_resumes_usecase.dart';
import 'package:intelliresume/domain/usecases/save_resume_usecase.dart';

// Camada de Infraestrutura (Firebase)
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Camada de Dados (DataSources e Repositories)
final resumeRemoteDataSourceProvider = Provider<ResumeRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return ResumeRemoteDataSourceImpl(firestore: firestore);
});

final resumeRepositoryProvider = Provider<ResumeRepository>((ref) {
  final remoteDataSource = ref.watch(resumeRemoteDataSourceProvider);
  return ResumeRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Camada de Domínio (UseCases)
final getResumesUsecaseProvider = Provider<GetResumesUsecase>((ref) {
  final repository = ref.watch(resumeRepositoryProvider);
  return GetResumesUsecase(repository);
});

final getResumeByIdUsecaseProvider = Provider<GetResumeByIdUsecase>((ref) {
  final repository = ref.watch(resumeRepositoryProvider);
  return GetResumeByIdUsecase(repository);
});

final saveResumeUsecaseProvider = Provider<SaveResumeUseCase>((ref) {
  final repository = ref.watch(resumeRepositoryProvider);
  return SaveResumeUseCase(repository);
});

