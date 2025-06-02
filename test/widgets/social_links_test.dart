import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/presentation/widgets/social_link.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  testWidgets('SocialLink displays and deletes correctly', (tester) async {
    var deleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SocialLink(
            icon: Icons.code,
            name: 'GitHub',
            url: 'https://github.com',
            textTheme: GoogleFonts.robotoTextTheme(),
            onDeleted: () => deleted = true,
          ),
        ),
      ),
    );

    expect(find.text('GitHub'), findsOneWidget);
    expect(find.byIcon(Icons.code), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(deleted, true);
  });
}
