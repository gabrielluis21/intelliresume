import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';

class SaveUserProfileUseCase {
  final UserProfileRepository _repository;

  SaveUserProfileUseCase(this._repository);

  Future<void> call(UserProfile profile) async {
    // O UseCase é o lugar perfeito para centralizar regras de negócio.
    // Por exemplo, podemos validar se o nome não está vazio antes de salvar.
    if (profile.name == null || profile.name!.isEmpty) {
      throw Exception('O nome do usuário não pode ser vazio.');
    }

    return _repository.saveProfile(profile);
  }
}
