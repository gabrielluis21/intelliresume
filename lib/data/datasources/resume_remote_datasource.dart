import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelliresume/data/models/cv_model.dart';

abstract class ResumeRemoteDataSource {
  Stream<List<CVModel>> getResumes(String userId);
  Future<CVModel> getResumeById(String userId, String resumeId);
  Future<void> saveResume(String userId, CVModel resume);
}

class ResumeRemoteDataSourceImpl implements ResumeRemoteDataSource {
  final FirebaseFirestore _firestore;

  ResumeRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Stream<List<CVModel>> getResumes(String userId) {
    return _firestore
        .collection('resumes')
        .doc(userId)
        .collection('user_resumes')
        .orderBy('lastModified', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // Adiciona o ID do documento ao mapa
            return CVModel.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<CVModel> getResumeById(String userId, String resumeId) async {
    final docSnapshot =
        await _firestore
            .collection('resumes')
            .doc(userId)
            .collection('user_resumes')
            .doc(resumeId)
            .get();

    if (!docSnapshot.exists) {
      throw Exception('Resume not found');
    }

    final data = docSnapshot.data()!;
    data['id'] = docSnapshot.id;
    return CVModel.fromJson(data);
  }

  @override
  Future<void> saveResume(String userId, CVModel resume) {
    return _firestore
        .collection('resumes')
        .doc(userId)
        .collection('user_resumes')
        .doc(resume.id)
        .set(resume.toJson());
  }
}
