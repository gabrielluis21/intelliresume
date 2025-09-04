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
  final PcdInfo? pcdInfo;

  UserProfile({
    this.uid,
    this.email,
    this.phone,
    this.name,
    this.profilePictureUrl,
    this.plan = PlanType.free,
    this.emailVerified = false,
    this.pcdInfo,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? profilePictureUrl,
    bool? emailVerified,
    PlanType? plan,
    PcdInfo? pcdInfo,
  }) {
    return UserProfile(
      uid: uid, // Mantém o uid original
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      plan: plan ?? this.plan,
      emailVerified: emailVerified ?? this.emailVerified,
      pcdInfo: pcdInfo ?? this.pcdInfo,
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
    'pcdInfo': pcdInfo?.toJson(),
  };

  static UserProfile fromJson(Map<String, dynamic> j) {
    return UserProfile(
      uid: j['uid'],
      email: j['email'],
      phone: j['phone'],
      name: j['displayName'],
      profilePictureUrl: j['photoURL'],
      plan: j['plan'] == 'PlanType.premium' ? PlanType.premium : PlanType.free,
      pcdInfo: j['pcdInfo'] != null ? PcdInfo.fromJson(j['pcdInfo']) : null,
    );
  }
}

class PcdInfo {
  // Campos de Acessibilidade
  final bool? isPCD;
  final List<String>? disabilityTypes;
  final String? disabilityDescription;

  PcdInfo({this.isPCD, this.disabilityTypes, this.disabilityDescription});

  factory PcdInfo.fromJson(Map<String, dynamic> json) => PcdInfo(
    isPCD: json['isPCD'],
    disabilityTypes: json['disabilityTypes']?.cast<String>(),
    disabilityDescription: json['disabilityDescription'],
  );

  Map<String, dynamic> toJson() => {
    'isPCD': isPCD,
    'disabilityTypes': disabilityTypes,
    'disabilityDescription': disabilityDescription,
  };
}
