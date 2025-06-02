import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intelliresume/presentation/widgets/resume_preview.dart';
import '../../lib/presentation/widgets/social_link.dart';
import 'package:intelliresume/core/providers/cv_provider.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  testWidgets('ResumePreview displays social links correctly', (tester) async {
    final cvData = CVData(
      socials: [
        {'type': 'GitHub', 'url': 'https://github.com'},
        {'type': 'LinkedIn', 'url': 'https://linkedin.com'},
      ],
      skills: ['Dart', 'Flutter'],
      objective: 'Software Engineer',
      experiences: ['Exp 1'],
      educations: ['Edu 1'],
    );

    final user = UserProfile(
      name: 'John Doe',
      email: 'john@example.com',
      phone: '1234567890',
      uid: '55fb16f5-c6ed-4de6-a562-afcad3797f59',
      profielePictureUrl: 'https://www.local.com/teste.png',
    );

    await tester.pumpWidget(MaterialApp(home: ResumePreview()));

    await tester.pumpAndSettle();

    expect(find.text('GitHub'), findsOneWidget);
    expect(find.text('LinkedIn'), findsOneWidget);
    expect(find.byIcon(Icons.code), findsOneWidget);
    expect(find.byIcon(Icons.link), findsOneWidget);
  });
}
