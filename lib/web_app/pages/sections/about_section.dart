import 'package:flutter/material.dart';
import 'package:intelliresume/core/utils/app_localizations.dart';

class AboutSection extends StatelessWidget {
  final GlobalKey aboutKey;
  static const Color _brandBlue = Color(0xFF0D47A1);

  const AboutSection({super.key, required this.aboutKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _brandBlue.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).aboutIntelliTitle,
            semanticsLabel: AppLocalizations.of(context).aboutIntelliTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context).aboutIntelliDescription,
            semanticsLabel:
                AppLocalizations.of(context).aboutIntelliDescription,
            style: TextStyle(height: 1.5),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
