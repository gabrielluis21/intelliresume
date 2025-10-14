import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelliresume/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<User?> call({required String email, required String password}) {
    return repository.signIn(email: email, password: password);
  }
}
