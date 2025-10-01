import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/data/datasources/local/local_user_profile_ds.dart';
import 'package:intelliresume/data/datasources/local/resume_local_ds.dart';
import 'package:intelliresume/data/datasources/remote/firestore_resume_ds.dart';
import 'package:intelliresume/data/datasources/remote/remote_resume_ds.dart';
import 'package:intelliresume/data/datasources/remote/remote_user_profile_ds.dart';
import 'package:intelliresume/data/repositories/resume_repository.dart';
import 'package:intelliresume/data/repositories/user_profile_repository.dart';

// --- User Profile Data Sources ---

final remoteUserProfileDSProvider = Provider<RemoteUserProfileDataSource>(
  (ref) => RemoteUserProfileDataSource(),
);

final localUserProfileDSProvider = Provider<LocalUserProfileDataSource>(
  (ref) => HiveUserProfileDataSource(),
);

// --- Resume Data Sources ---

final remoteResumeDSProvider = Provider<RemoteResumeDataSource>(
  (ref) => FirestoreResumeDataSource(),
);

final localResumeDSProvider = Provider<LocalResumeDataSource>(
  (ref) => HiveResumeDataSource(),
);

// --- Repositories ---

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final remoteDS = ref.watch(remoteUserProfileDSProvider);
  final localDS = ref.watch(localUserProfileDSProvider);
  return UserProfileRepositoryImpl(remote: remoteDS, local: localDS);
});

final resumeRepositoryProvider = Provider<ResumeRepository>((ref) {
  final remoteDS = ref.watch(remoteResumeDSProvider);
  final localDS = ref.watch(localResumeDSProvider);
  return ResumeRepositoryImpl(remote: remoteDS, local: localDS);
});
