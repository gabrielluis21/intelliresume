import '../../../domain/entities/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../datasources/remote/auth_resume_ds.dart';

abstract class UserProfileDataSource {
  Future<void> saveProfile(UserProfile profile);
  Future<UserProfile?> fetchProfile(String uid);
  Future<void> deleteProfile(String uid);
  Future<void> verifyProfileEmail();
  Stream<UserProfile> watchProfile(String uid);
}

class RemoteUserProfileDataSource implements UserProfileDataSource {
  final FirebaseFirestore _firestore;
  final authService = AuthService.instance;

  RemoteUserProfileDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserProfile?> fetchProfile(String uid) async {
    final doc = await _firestore.collection('user_profiles').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserProfile.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _firestore
        .collection('user_profiles')
        .doc(profile.uid)
        .set(profile.toJson());
  }

  @override
  Future<void> deleteProfile(String uid) async {
    await _firestore.collection('user_profiles').doc(uid).delete();
  }

  @override
  Future<void> verifyProfileEmail() async {
    authService.verifyUserEmail();
  }

  @override
  Stream<UserProfile> watchProfile(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .handleError((error) {
          throw Exception('Failed to watch profile: $error');
        })
        .map((snapshot) {
          if (!snapshot.exists) {
            throw Exception('User profile not found');
          }
          final data = snapshot.data()!;
          return UserProfile(
            uid: uid,
            name: data['displayName'],
            email: data['email'],
            profilePictureUrl: data['profilePictureUrl'],
            phone: data['phone'],
            plan: PlanType.values.firstWhere(
              (e) => e.toString() == 'PlanType.${data['plan']}',
              orElse: () => PlanType.free,
            ),
          );
        });
  }
}
