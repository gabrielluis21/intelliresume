import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelliresume/data/datasources/local/resume_local_ds.dart';
import 'data/datasources/remote/firestore_resume_ds.dart';
import 'data/repositories/resume_repository.dart';
import 'domain/usecases/save_resume_usecase.dart';

final remoteDs = FirestoreResumeDataSource(
  instance: FirebaseFirestore.instance,
);
final localDs = HiveResumeDataSource();
// Se quiser usar a API REST, comente a linha acima e descomente a abaixo:
// final remoteDs = ApiResumeDataSource(baseUrl: 'https://sua-api.com');

final resumeRepository = ResumeRepositoryImpl(remote: remoteDs, local: localDs);
final saveResumeUseCase = SaveResumeUseCase(resumeRepository);
