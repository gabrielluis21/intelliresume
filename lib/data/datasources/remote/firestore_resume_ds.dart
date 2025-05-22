// lib/data/datasources/remote/firestore_resume_ds.dart

import 'remote_resume_ds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementação Firebase de RemoteResumeDataSource.
class FirestoreResumeDataSource implements RemoteResumeDataSource {
  final FirebaseFirestore _firestore;
  FirestoreResumeDataSource({FirebaseFirestore? instance})
    : _firestore = instance ?? FirebaseFirestore.instance;

  static const _collection = 'resumes';

  @override
  Future<void> saveResume(String userId, Map<String, dynamic> data) {
    return _firestore.collection(_collection).doc(userId).set(data);
  }

  @override
  Future<Map<String, dynamic>?> fetchResume(String userId) async {
    final doc = await _firestore.collection(_collection).doc(userId).get();
    return doc.exists ? doc.data() : null;
  }
}
