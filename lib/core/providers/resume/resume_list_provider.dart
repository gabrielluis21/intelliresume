import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/data/models/cv_model.dart';

final resumeListProvider = StreamProvider<List<CVModel>>((ref) {
  final user = ref.watch(userProfileProvider).value;
  if (user == null) {
    return Stream.value([]);
  }

  final firestore = FirebaseFirestore.instance;
  final collectionRef = firestore
      .collection('users')
      .doc(user.uid)
      .collection('resumes')
      .orderBy('lastModified', descending: true);

  return collectionRef.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final resumeData = ResumeData.fromJson(data);
      final timestamp = data['lastModified'] as Timestamp?;

      return CVModel(
        id: doc.id,
        title: resumeData.personalInfo?.name ?? 'Currículo Salvo',
        data: resumeData,
        dateCreated: timestamp?.toDate() ?? DateTime.now(),
        lastModified: timestamp?.toDate() ?? DateTime.now(),
        status:
            data['status'] == 'draft'
                ? ResumeStatus.draft
                : ResumeStatus.finalized,
      );
    }).toList();
  });
});
