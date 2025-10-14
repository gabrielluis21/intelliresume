import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/data/datasources/local/local_user_profile_ds.dart';
import 'package:intelliresume/data/datasources/local/resume_local_ds.dart';
import 'package:intelliresume/data/datasources/remote/firestore_resume_ds.dart';
import 'package:intelliresume/data/datasources/remote/remote_resume_ds.dart';
import 'package:intelliresume/data/datasources/remote/remote_user_profile_ds.dart';
import 'package:intelliresume/data/repositories/auth_repository_impl.dart';
import 'package:intelliresume/data/repositories/resume_repository.dart';
import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/repositories/auth_repository.dart';
import 'package:intelliresume/domain/usecases/get_auth_state_changes_usecase.dart';
import 'package:intelliresume/domain/usecases/get_current_user_usecase.dart';
import 'package:intelliresume/domain/usecases/send_password_reset_usecase.dart';
import 'package:intelliresume/domain/usecases/sign_in_usecase.dart';
import 'package:intelliresume/domain/usecases/sign_out_usecase.dart';
import 'package:intelliresume/domain/usecases/sign_up_usecase.dart';

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

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

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

// --- Auth Use Cases ---

final getAuthStateChangesUseCaseProvider = Provider<GetAuthStateChangesUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetAuthStateChangesUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInUseCase(repository);
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repository);
});

final sendPasswordResetUseCaseProvider = Provider<SendPasswordResetUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SendPasswordResetUseCase(repository);
});