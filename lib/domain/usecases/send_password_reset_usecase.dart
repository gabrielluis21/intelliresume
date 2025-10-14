import 'package:intelliresume/domain/repositories/auth_repository.dart';

class SendPasswordResetUseCase {
  final AuthRepository repository;

  SendPasswordResetUseCase(this.repository);

  Future<void> call({required String email}) {
    return repository.sendPasswordReset(email: email);
  }
}
