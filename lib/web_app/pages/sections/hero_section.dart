import 'package:flutter/material.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/web_app/pages/sections/section_title.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onCTAPressed;
  static const Color _brandBlue = Color(0xFF0D47A1);

  const HeroSection({super.key, required this.onCTAPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  title: l10n.heroTitle,
                  subtitle: l10n.heroSubtitle,
                  textColor: Theme.of(context).textTheme.headlineLarge?.color,
                ),
                const SizedBox(height: 24),
                Semantics(
                  button: true,
                  label: l10n.heroCTA,
                  child: ElevatedButton(
                    onPressed: onCTAPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brandBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(l10n.heroCTA),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40, height: 40),
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Image.asset(
              'images/logo-transparente.png',
              fit: BoxFit.contain,
              height: 250,
              width: 360,
              semanticLabel: l10n.heroLogoSemanticLabel,
            ),
          ),
        ],
      ),
    );
  }
}
