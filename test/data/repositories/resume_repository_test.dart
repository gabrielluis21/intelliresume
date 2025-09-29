
// test/data/repositories/resume_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:intelliresume/data/datasources/local/resume_local_ds.dart';
import 'package:intelliresume/data/datasources/remote/remote_resume_ds.dart';
import 'package:intelliresume/data/repositories/resume_repository.dart';

import 'resume_repository_test.mocks.dart';

@GenerateMocks([LocalResumeDataSource, RemoteResumeDataSource])
void main() {
  late ResumeRepositoryImpl repository;
  late MockLocalResumeDataSource mockLocalDataSource;
  late MockRemoteResumeDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalResumeDataSource();
    mockRemoteDataSource = MockRemoteResumeDataSource();
    repository = ResumeRepositoryImpl(
      local: mockLocalDataSource,
      remote: mockRemoteDataSource,
    );
  });

  const tUserId = 'testUser';
  final tResumeData = {'title': 'My Test Resume'};

  group('save', () {
    test(
      'deve chamar cacheResume no local e depois saveResume no remoto',
      () async {
        // Arrange
        when(mockLocalDataSource.cacheResume(any, any))
            .thenAnswer((_) async => Future.value());
        when(mockRemoteDataSource.saveResume(any, any))
            .thenAnswer((_) async => Future.value());

        // Act
        await repository.save(tUserId, tResumeData);

        // Assert
        // Verifica se os métodos foram chamados na ordem correta
        verifyInOrder([
          mockLocalDataSource.cacheResume(tUserId, tResumeData),
          mockRemoteDataSource.saveResume(tUserId, tResumeData)
        ]);
        verifyNoMoreInteractions(mockLocalDataSource);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  // Adicionaremos os testes para o método 'load' aqui.

  group('load', () {
    // O teste original não simulava a constante kIsWeb.
    // Para os testes de unidade, podemos ignorá-la e testar a lógica principal.

    test(
      'deve retornar dados do cache local quando disponíveis (não-Web)',
      () async {
        // Arrange
        when(mockLocalDataSource.getCachedResume(tUserId))
            .thenAnswer((_) async => tResumeData);

        // Act
        final result = await repository.load(tUserId);

        // Assert
        expect(result, tResumeData);
        verify(mockLocalDataSource.getCachedResume(tUserId));
        verifyNoMoreInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource); // Remoto não deve ser chamado
      },
    );

    test(
      'deve buscar do remoto, salvar no cache e retornar os dados quando o cache local está vazio (não-Web)',
      () async {
        // Arrange
        when(mockLocalDataSource.getCachedResume(tUserId))
            .thenAnswer((_) async => null); // Cache vazio
        when(mockRemoteDataSource.fetchResume(tUserId))
            .thenAnswer((_) async => tResumeData); // Remoto tem dados
        when(mockLocalDataSource.cacheResume(tUserId, tResumeData))
            .thenAnswer((_) async {}); // Cache bem-sucedido

        // Act
        final result = await repository.load(tUserId);

        // Assert
        expect(result, tResumeData);
        // Verifica a sequência de chamadas
        verifyInOrder([
          mockLocalDataSource.getCachedResume(tUserId),
          mockRemoteDataSource.fetchResume(tUserId),
          mockLocalDataSource.cacheResume(tUserId, tResumeData)
        ]);
        verifyNoMoreInteractions(mockLocalDataSource);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
