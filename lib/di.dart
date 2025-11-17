import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/data/datasources/resume_remote_datasource.dart';
import 'package:intelliresume/data/repositories/linkedin_repository_impl.dart';
import 'package:intelliresume/data/repositories/resume_repository_impl.dart';
import 'package:intelliresume/domain/repositories/linkedin_repository.dart';
import 'package:intelliresume/domain/repositories/resume_repository.dart';
import 'package:intelliresume/domain/usecases/get_resume_by_id_usecase.dart';
import 'package:intelliresume/domain/usecases/get_resumes_usecase.dart';
import 'package:intelliresume/domain/usecases/import_linkedin_profile_usecase.dart';
import 'package:intelliresume/domain/usecases/save_resume_usecase.dart';
import 'package:intelliresume/domain/usecases/signin_with_linkedin_usecase.dart';
import 'package:intelliresume/data/datasources/user_remote_datasource.dart';
import 'package:intelliresume/data/repositories/user_repository_impl.dart';
import 'package:intelliresume/domain/repositories/user_repository.dart';
import 'package:intelliresume/domain/usecases/save_user_usecase.dart';

// Camada de Infraestrutura (Firebase, HTTP, etc)
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
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

final linkedInRepositoryProvider = Provider<LinkedInRepository>((ref) {
  return LinkedInRepositoryImpl();
});

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return UserRemoteDataSourceImpl(firestore: firestore);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource: remoteDataSource);
});

final saveUserUseCaseProvider = Provider<SaveUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return SaveUserUseCase(repository);
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

final signInWithLinkedInUseCaseProvider = Provider<SignInWithLinkedInUseCase>((
  ref,
) {
  final repository = ref.watch(linkedInRepositoryProvider);
  return SignInWithLinkedInUseCase(repository);
});

final importLinkedInProfileUseCaseProvider =
    Provider<ImportLinkedInProfileUseCase>((ref) {
      final repository = ref.watch(linkedInRepositoryProvider);
      return ImportLinkedInProfileUseCase(repository);
    });
