import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelliresume/domain/repositories/user_repository.dart';

class SaveUserUseCase {
  final UserRepository repository;

  SaveUserUseCase(this.repository);

  Future<void> call(User user) async {
    await repository.saveUser(user);
  }
}
