import 'package:intelliresume/domain/entities/linkedin_profile_entity.dart';

import 'package:flutter/material.dart';

abstract class LinkedInRepository {
  Future<void> signIn(BuildContext context, {String? nextUrl});
  Future<LinkedInProfileEntity> importProfile();
}
