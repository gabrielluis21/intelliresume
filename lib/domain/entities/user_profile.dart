// lib/domain/entities/user_profile.dart

import 'package:intelliresume/domain/entities/plan_type.dart';

class UserProfile {
  String? uid;
  final String? email;
  final String? phone;
  final String? name;
  final String? profilePictureUrl;
  final bool emailVerified;
  final PlanType plan;

  // Campos de Acessibilidade
  final bool isPCD;
  final List<String> disabilityTypes;
  final String? disabilityDescription;

  UserProfile({
    this.uid,
    this.email,
    this.phone,
    this.name,
    this.profilePictureUrl,
    this.plan = PlanType.free,
    this.emailVerified = false,
    this.isPCD = false,
    this.disabilityTypes = const [],
    this.disabilityDescription,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? profilePictureUrl,
    bool? emailVerified,
    PlanType? plan,
    bool? isPCD,
    List<String>? disabilityTypes,
    String? disabilityDescription,
  }) {
    return UserProfile(
      uid: uid, // Mantém o uid original
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      plan: plan ?? this.plan,
      emailVerified: emailVerified ?? this.emailVerified,
      isPCD: isPCD ?? this.isPCD,
      disabilityTypes: disabilityTypes ?? this.disabilityTypes,
      disabilityDescription: disabilityDescription ?? this.disabilityDescription,
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
        // Acessibilidade
        'isPCD': isPCD,
        'disabilityTypes': disabilityTypes,
        'disabilityDescription': disabilityDescription,
      };

  static UserProfile fromJson(Map<String, dynamic> j) {
    return UserProfile(
      uid: j['uid'],
      email: j['email'],
      phone: j['phone'],
      name: j['displayName'],
      profilePictureUrl: j['photoURL'],
      plan: j['plan'] == 'PlanType.premium' ? PlanType.premium : PlanType.free,
      // Acessibilidade
      isPCD: j['isPCD'] ?? false,
      disabilityTypes: List<String>.from(j['disabilityTypes'] ?? []),
      disabilityDescription: j['disabilityDescription'],
    );
  }
}
