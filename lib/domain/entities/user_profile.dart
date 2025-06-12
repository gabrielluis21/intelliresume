// lib/domain/entities/user_profile.dart

enum PlanType { free, premium }

class UserProfile {
  final String? uid;
  final String? email;
  final String? phone;
  final String? name;
  final String? profilePictureUrl;
  final bool emailVerified;
  final PlanType plan;

  UserProfile({
    this.uid,
    this.email,
    this.phone,
    this.name,
    this.profilePictureUrl,
    this.plan = PlanType.free,
    this.emailVerified = false,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? profilePictureUrl,
    bool? emailVerified,
    PlanType? plan,
  }) {
    return UserProfile(
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      plan: plan ?? this.plan,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'phone': phone,
    'name': name,
    'photoURL': profilePictureUrl,
    'emailVerified': emailVerified,
    'plan': plan.toString(),
  };

  static UserProfile fromJson(Map<String, dynamic> j) {
    return UserProfile(
      uid: j['uid'],
      email: j['email'],
      phone: j['phone'],
      name: j['displayName'],
      profilePictureUrl: j['photoURL'],
      plan: j['plan'] == 'PlanType.premium' ? PlanType.premium : PlanType.free,
    );
  }
}
