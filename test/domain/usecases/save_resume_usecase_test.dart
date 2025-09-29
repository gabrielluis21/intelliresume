
// test/domain/usecases/save_resume_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:intelliresume/data/repositories/resume_repository.dart';
import 'package:intelliresume/domain/usecases/save_resume_usecase.dart';

import 'save_resume_usecase_test.mocks.dart';

// A anotação @GenerateMocks cria um arquivo .mocks.dart com as classes mockadas.
@GenerateMocks([ResumeRepository])
void main() {
  // Declaração das variáveis que serão usadas nos testes
  late SaveResumeUseCase usecase;
  late MockResumeRepository mockResumeRepository;

  // O setUp é executado antes de cada teste
  setUp(() {
    // Instancia o mock e o caso de uso
    mockResumeRepository = MockResumeRepository();
    usecase = SaveResumeUseCase(mockResumeRepository);
  });

  // Dados de teste
  const tUserId = 'testUser';
  final tResumeData = {'title': 'My Awesome Resume'};

  test(
    'deve chamar o método save do repositório com os dados corretos',
    () async {
      // Arrange (Organizar)
      // Configura o mock para retornar um Future<void> quando 'save' for chamado com quaisquer argumentos.
      when(mockResumeRepository.save(any, any))
          .thenAnswer((_) async => Future.value());

      // Act (Agir)
      // Executa o caso de uso
      await usecase(tUserId, tResumeData);

      // Assert (Verificar)
      // Verifica se o método 'save' do repositório foi chamado exatamente uma vez
      // com o userId e os dados do currículo corretos.
      verify(mockResumeRepository.save(tUserId, tResumeData));
      
      // Garante que nenhuma outra interação ocorreu com o mock.
      verifyNoMoreInteractions(mockResumeRepository);
    },
  );
}
