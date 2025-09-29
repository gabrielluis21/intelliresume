import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/data/repositories/user_profile_repository.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';

import 'user_provider_test.mocks.dart';

// Gera mocks para todas as dependências externas
@GenerateMocks([UserProfileRepository, FirebaseAuth, User])
void main() {
  late MockUserProfileRepository mockRepository;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockRepository = MockUserProfileRepository();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
  });

  final tUserProfile = UserProfile(
    uid: 'testUser',
    name: 'Test User',
    email: 'test@example.com',
    plan: PlanType.free,
  );

  // Função auxiliar para criar o ProviderContainer com as overrides
  ProviderContainer createContainer({
    MockUser? currentUser,
  }) {
    // Configura o mock do usuário
    when(mockUser.uid).thenReturn('testUser');
    // Configura o mock do auth para retornar o usuário
    when(mockAuth.currentUser).thenReturn(currentUser);

    return ProviderContainer(
      overrides: [
        userProfileRepositoryProvider.overrideWithValue(mockRepository),
        firebaseAuthProvider.overrideWithValue(mockAuth),
      ],
    );
  }

  test('quando o usuário está logado, _init deve buscar o perfil', () async {
    // Arrange
    when(mockRepository.getCachedProfile(any)).thenAnswer((_) async => null);
    when(mockRepository.watchProfile(any)).thenAnswer((_) => Stream.value(tUserProfile));

    final container = createContainer(currentUser: mockUser);
    
    // Cria um Future que completará quando o estado não for mais de loading
    final completer = Completer<void>();
    container.listen(
      userProfileProvider,
      (previous, next) {
        if (next is! AsyncLoading) {
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      },
      fireImmediately: true,
    );

    // Act
    // Aguarda o estado mudar de AsyncLoading para AsyncData/AsyncError
    await completer.future;

    // Assert
    final state = container.read(userProfileProvider);
    expect(state, isA<AsyncData<UserProfile?>>());
    expect(state.value, tUserProfile);

    verify(mockAuth.currentUser);
    verify(mockRepository.watchProfile('testUser'));
  });

  test('quando o usuário não está logado, o estado deve ser data(null)', () async {
    // Arrange (nenhum mock de repositório é necessário aqui)

    // Act
    final container = createContainer(currentUser: null); // Usuário é null
    await Future.delayed(const Duration(milliseconds: 100));

    // Assert
    final state = container.read(userProfileProvider);
    expect(state, isA<AsyncData<UserProfile?>>());
    expect(state.value, isNull);
    verify(mockAuth.currentUser);
    verifyZeroInteractions(mockRepository); // Repositório não deve ser chamado
  });

  test('loadUser deve buscar e atualizar o estado para o perfil correto', () async {
    // Arrange
    when(mockRepository.loadProfile(any)).thenAnswer((_) async => tUserProfile);
    final container = createContainer(currentUser: null); // Começa deslogado

    // Act
    await container.read(userProfileProvider.notifier).loadUser('testUser');

    // Assert
    final state = container.read(userProfileProvider);
    expect(state.value, tUserProfile);
    verify(mockRepository.loadProfile('testUser'));
  });
}