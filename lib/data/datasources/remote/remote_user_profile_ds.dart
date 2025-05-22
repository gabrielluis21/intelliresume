import '../../../domain/entities/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserProfileDataSource {
  Future<void> saveProfile(UserProfile profile);
  Future<UserProfile?> fetchProfile(String uid);
}

class RemoteUserProfileDataSource implements UserProfileDataSource {
  final FirebaseFirestore _firestore;

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
}
