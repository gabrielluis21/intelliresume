// lib/domain/entities/user_profile.dart

enum PlanType { free, premium }

class UserProfile {
  final String uid;
  final String email;
  final PlanType plan;

  UserProfile({
    required this.uid,
    required this.email,
    this.plan = PlanType.free,
  });

  UserProfile copyWith({PlanType? plan}) {
    return UserProfile(uid: uid, email: email, plan: plan ?? this.plan);
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'plan': plan.toString(),
  };

  static UserProfile fromJson(Map<String, dynamic> j) {
    return UserProfile(
      uid: j['uid'],
      email: j['email'],
      plan: j['plan'] == 'PlanType.premium' ? PlanType.premium : PlanType.free,
    );
  }
}
