import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelliresume/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<User> signIn({required String email, required String password}) {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((c) => c.user!);
  }

  @override
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
      'plan': 'free', // Adiciona o plano inicial como gratuito
      if (disabilityInfo != null && disabilityInfo.isNotEmpty)
        'pcdInfo': {'disabilityDescription': disabilityInfo},
    };

    await _firestore.collection('users').doc(user.uid).set(userData);
    return user;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> sendPasswordReset({required String email}) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User> signInWithLinkedIn() {
    // TODO: Implementar fluxo de autenticação com LinkedIn via backend.
    // Conforme a análise, isso requer um endpoint seguro para trocar o token
    // do LinkedIn por um token customizado do Firebase.
    throw UnimplementedError(
      'O login com LinkedIn requer um endpoint de backend para ser implementado com segurança.',
    );
  }
}
