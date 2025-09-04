import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User> signIn({required String email, required String password}) =>
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((c) => c.user!);

  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
    String? disabilityInfo,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw Exception('Não foi possível criar o usuário.');
    }

    await user.updateDisplayName(displayName);

    final userData = {
      'uid': user.uid,
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
      if (disabilityInfo != null && disabilityInfo.isNotEmpty)
        'disabilityInfo': disabilityInfo,
    };

    await _firestore.collection('users').doc(user.uid).set(userData);

    return user;
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> verifyUserEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}
