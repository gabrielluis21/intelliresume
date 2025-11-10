import 'package:flutter/material.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:intelliresume/generated/app_localizations.dart';

class PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final List<String> features;
  final PlanType planType;
  final PlanType? currentUserPlan;
  final bool isRecommended;
  final Function(PlanType) onSelectPlan;

  final String? buttonText;

  const PricingCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    required this.planType,
    this.currentUserPlan,
    this.isRecommended = false,
    required this.onSelectPlan,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isCurrentUserPlan = currentUserPlan == planType;
    final bool canUpgrade =
        (currentUserPlan != null && planType.index > currentUserPlan!.index) ||
        currentUserPlan == null;

    return Card(
      elevation: isRecommended ? 8.0 : 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side:
            isRecommended
                ? BorderSide(color: theme.colorScheme.primary, width: 2)
                : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              price,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            ...features.map((feature) => _buildFeature(feature, theme, l10n)),
            const Spacer(),
            const SizedBox(height: 24),
            _buildButton(context, isCurrentUserPlan, canUpgrade, l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String text, ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: theme.colorScheme.primary,
            size: 20,
            semanticLabel: l10n.pricing_featureIncluded,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    bool isCurrentUserPlan,
    bool canUpgrade,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    if (isCurrentUserPlan) {
      return Center(
        child: Chip(
          label: Text(
            l10n.pricing_yourCurrentPlan,
            style: theme.textTheme.bodyMedium,
          ),
          backgroundColor: Colors.grey,
        ),
      );
    }

    if (planType == PlanType.free) {
      return const SizedBox.shrink(); // No button for the free plan
    }

    return ElevatedButton(
      key: Key('select_plan_${planType.name}_button'),
      onPressed: canUpgrade ? () => onSelectPlan(planType) : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor:
            isRecommended ? Theme.of(context).colorScheme.primary : null,
        foregroundColor:
            isRecommended ? Theme.of(context).colorScheme.onPrimary : null,
      ),
      child: Text(
        buttonText ??
            (canUpgrade ? l10n.pricing_upgrade : l10n.pricing_notAvailable),
      ),
    );
  }
}
