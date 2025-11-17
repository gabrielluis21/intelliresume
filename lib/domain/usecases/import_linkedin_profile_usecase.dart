import 'package:intelliresume/domain/entities/linkedin_profile_entity.dart';
import 'package:intelliresume/domain/repositories/linkedin_repository.dart';

class ImportLinkedInProfileUseCase {
  final LinkedInRepository repository;

  ImportLinkedInProfileUseCase(this.repository);

  Future<LinkedInProfileEntity> call() {
    return repository.importProfile();
  }
}
