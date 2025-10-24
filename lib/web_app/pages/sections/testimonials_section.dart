import 'package:flutter/material.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/web_app/pages/sections/section_title.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      color: Colors.white,
      child: Column(
        children: [
          SectionTitle(
            title: l10n.testimonialsSection_title,
            subtitle: l10n.testimonialsSection_subtitle,
          ),
          // Testimonials will be loaded dynamically here
        ],
      ),
    );
  }
}
