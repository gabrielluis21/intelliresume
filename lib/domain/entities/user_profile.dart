// lib/domain/entities/user_profile.dart

enum PlanType { free, premium }

class UserProfile {
  final String? uid;
  final String? email;
  final String? phone;
  final String? name;
  final String? profielePictureUrl;
  final PlanType plan;

  UserProfile({
    required this.uid,
    required this.email,
    required this.phone,
    required this.name,
    required this.profielePictureUrl,
    this.plan = PlanType.free,
  });

  UserProfile copyWith({PlanType? plan}) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name,
      phone: phone,
      profielePictureUrl: profielePictureUrl,
      plan: plan ?? this.plan,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'phone': phone,
    'name': name,
    'profielePictureUrl': profielePictureUrl,
    'plan': plan.toString(),
  };

  static UserProfile fromJson(Map<String, dynamic> j) {
    return UserProfile(
      uid: j['uid'],
      email: j['email'],
      phone: j['phone'],
      name: j['name'],
      profielePictureUrl: j['profielePictureUrl'],
      plan: j['plan'] == 'PlanType.premium' ? PlanType.premium : PlanType.free,
    );
  }
}
