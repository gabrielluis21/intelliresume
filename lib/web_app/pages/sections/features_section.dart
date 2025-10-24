import 'package:flutter/material.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/web_app/widgets/clickable_feature_card.dart';
import 'package:intelliresume/web_app/widgets/feature_card.dart';
import 'package:intelliresume/web_app/pages/sections/section_title.dart';

class FeaturesSection extends StatelessWidget {
  final GlobalKey featuresKey;
  final VoidCallback onSeeTemplates;

  const FeaturesSection({
    super.key,
    required this.featuresKey,
    required this.onSeeTemplates,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      key: featuresKey,
      color: Colors.grey[50], // Um fundo suave para diferenciar a seção
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          SectionTitle(
            title: l10n.featuresSection_title,
            subtitle: l10n.featuresSection_subtitle,
            textColor: const Color(0xFF0D47A1),
          ),
          const SizedBox(height: 40),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1200,
              ), // Limita a largura do grid
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    child: FeatureCard(
                      icon: Icons.auto_awesome,
                      title: l10n.feature_aiEvaluation_title,
                      description: l10n.feature_aiEvaluation_description,
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: FeatureCard(
                      icon: Icons.translate,
                      title: l10n.feature_autoTranslation_title,
                      description: l10n.feature_autoTranslation_description,
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: FeatureCard(
                      icon: Icons.spellcheck,
                      title: l10n.feature_spellCheck_title,
                      description: l10n.feature_spellCheck_description,
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: ClickableFeatureCard(
                      onTap: onSeeTemplates,
                      icon: Icons.palette,
                      title: l10n.feature_professionalTemplates_title,
                      description:
                          l10n.feature_professionalTemplates_description,
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: FeatureCard(
                      icon: Icons.edit,
                      title: l10n.feature_studioMode_title,
                      description: l10n.feature_studioMode_description,
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: FeatureCard(
                      icon: Icons.picture_as_pdf,
                      title: l10n.feature_easyExport_title,
                      description: l10n.feature_easyExport_description,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
