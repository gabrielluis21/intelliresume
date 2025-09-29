
// test/domain/usecases/update_plan_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:intelliresume/domain/usecases/update_plan_usecase.dart';

import 'update_plan_usecase_test.mocks.dart';

@GenerateMocks([UserProfileRepository])
void main() {
  late UpdatePlanUseCase usecase;
  late MockUserProfileRepository mockUserProfileRepository;

  setUp(() {
    mockUserProfileRepository = MockUserProfileRepository();
    usecase = UpdatePlanUseCase(mockUserProfileRepository);
  });

  const tUserId = 'testUser';
  final tInitialProfile = UserProfile(
    uid: tUserId,
    name: 'Test User',
    email: 'test@example.com',
    plan: PlanType.free,
  );

  test(
    'deve atualizar o plano do usuário e salvar o perfil',
    () async {
      // Arrange
      // Quando loadProfile for chamado, retorna o perfil inicial
      when(mockUserProfileRepository.loadProfile(tUserId))
          .thenAnswer((_) async => tInitialProfile);
      
      // Configura o saveProfile para completar com sucesso
      when(mockUserProfileRepository.saveProfile(any))
          .thenAnswer((_) async => Future.value());

      // Act
      // Executa o caso de uso para atualizar o plano para Premium
      final result = await usecase(tUserId, PlanType.premium);

      // Assert
      // Verifica se o loadProfile foi chamado com o ID de usuário correto
      verify(mockUserProfileRepository.loadProfile(tUserId));

      // Captura o argumento que foi passado para o saveProfile
      final captured = verify(mockUserProfileRepository.saveProfile(captureAny)).captured;
      final savedProfile = captured.first as UserProfile;

      // Verifica se o perfil salvo tem o plano atualizado
      expect(savedProfile.plan, PlanType.premium);
      
      // Verifica se o resultado retornado também tem o plano atualizado
      expect(result.plan, PlanType.premium);

      // Garante que nenhuma outra interação ocorreu
      verifyNoMoreInteractions(mockUserProfileRepository);
    },
  );
}
