import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelliresume/domain/repositories/auth_repository.dart';

class GetAuthStateChangesUseCase {
  final AuthRepository repository;

  GetAuthStateChangesUseCase(this.repository);

  Stream<User?> call() {
    return repository.authStateChanges;
  }
}
