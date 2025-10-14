import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelliresume/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<User?> call({
    required String email,
    required String password,
    required String displayName,
    String? disabilityInfo,
  }) {
    return repository.signUp(
      email: email,
      password: password,
      displayName: displayName,
      disabilityInfo: disabilityInfo,
    );
  }
}
