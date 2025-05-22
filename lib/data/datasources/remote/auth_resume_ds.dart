import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();
  final _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User> signIn({required String email, required String password}) =>
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((c) => c.user!);

  Future<User> signUp({required String email, required String password}) =>
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((c) => c.user!);

  Future<void> signOut() => _auth.signOut();
}
