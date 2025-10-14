// lib/domain/repositories/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<User> signIn({required String email, required String password});
  Future<User> signInWithLinkedIn();
  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
    String? disabilityInfo,
  });
  Future<void> signOut();
  Future<void> sendPasswordReset({required String email});
}
