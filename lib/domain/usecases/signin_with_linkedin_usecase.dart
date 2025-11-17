import 'package:flutter/material.dart';
import 'package:intelliresume/domain/repositories/linkedin_repository.dart';

class SignInWithLinkedInUseCase {
  final LinkedInRepository repository;

  SignInWithLinkedInUseCase(this.repository);

  Future<void> call(BuildContext context, {String? nextUrl}) {
    return repository.signIn(context, nextUrl: nextUrl);
  }
}
