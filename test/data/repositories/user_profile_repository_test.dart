
// test/data/repositories/user_profile_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:intelliresume/data/datasources/local/local_user_profile_ds.dart';
import 'package:intelliresume/data/datasources/remote/remote_user_profile_ds.dart';
import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';

// Gera os arquivos de mock com o comando: flutter pub run build_runner build
@GenerateMocks([RemoteUserProfileDataSource, LocalUserProfileDataSource])
import 'user_profile_repository_test.mocks.dart';

void main() {
  late UserProfileRepositoryImpl repository;
  late MockRemoteUserProfileDataSource mockRemoteDataSource;
  late MockLocalUserProfileDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteUserProfileDataSource();
    mockLocalDataSource = MockLocalUserProfileDataSource();
    repository = UserProfileRepositoryImpl(
      remote: mockRemoteDataSource,
      local: mockLocalDataSource,
    );
  });

  group('UserProfileRepository', () {
    final userProfile = UserProfile(uid: '123', email: 'test@test.com', name: 'Test User');

    test('saveProfile deve chamar os métodos save nos DataSources remoto e local', () async {
      // Configura o comportamento esperado dos mocks
      when(mockRemoteDataSource.saveProfile(any)).thenAnswer((_) async => Future.value());
      when(mockLocalDataSource.saveProfile(any, any)).thenAnswer((_) async => Future.value());

      // Chama o método a ser testado
      await repository.saveProfile(userProfile);

      // Verifica se os métodos dos mocks foram chamados com os parâmetros corretos
      verify(mockRemoteDataSource.saveProfile(userProfile)).called(1);
      verify(mockLocalDataSource.saveProfile(userProfile.uid!, userProfile.toJson())).called(1);
    });

    // Testes para os métodos ainda não implementados
    
    test('updateProfile deve chamar os métodos de atualização nos DataSources', () async {
      // Arrange: Configure o comportamento esperado dos mocks
      when(mockRemoteDataSource.updateProfile(any)).thenAnswer((_) async => Future.value());
      when(mockLocalDataSource.saveProfile(any, any)).thenAnswer((_) async => Future.value());

      // Act: Chama o método a ser testado
      await repository.updateProfile(userProfile);

      // Assert: Verifica se os métodos dos mocks foram chamados
      verify(mockRemoteDataSource.updateProfile(userProfile)).called(1);
      verify(mockLocalDataSource.saveProfile(userProfile.uid!, userProfile.toJson())).called(1);
    });

    test('deleteProfile deve chamar os métodos de exclusão nos DataSources', () async {
      // Arrange
      const uid = '123';
      when(mockRemoteDataSource.deleteProfile(any)).thenAnswer((_) async => Future.value());
      when(mockLocalDataSource.deleteProfile(any)).thenAnswer((_) async => Future.value());

      // Act
      await repository.deleteProfile(uid);

      // Assert
      verify(mockRemoteDataSource.deleteProfile(uid)).called(1);
      verify(mockLocalDataSource.deleteProfile(uid)).called(1);
    });

    test('verifyProfileEmail deve chamar o método no DataSource remoto', () async {
      // Arrange
      when(mockRemoteDataSource.verifyProfileEmail()).thenAnswer((_) async => Future.value());

      // Act
      await repository.verifyProfileEmail();

      // Assert
      verify(mockRemoteDataSource.verifyProfileEmail()).called(1);
    });
  });
}
