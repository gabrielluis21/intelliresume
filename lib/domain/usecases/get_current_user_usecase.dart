import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelliresume/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  User? call() {
    return repository.currentUser;
  }
}
