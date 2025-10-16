import 'package:flutter/material.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';

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
            ...features.map((feature) => _buildFeature(feature, theme)),
            const Spacer(),
            const SizedBox(height: 24),
            _buildButton(context, isCurrentUserPlan, canUpgrade),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: theme.colorScheme.primary,
            size: 20,
            semanticLabel: 'Recurso incluso',
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    bool isCurrentUserPlan,
    bool canUpgrade,
  ) {
    if (isCurrentUserPlan) {
      return const Center(
        child: Chip(
          label: Text('Seu Plano Atual'),
          backgroundColor: Colors.grey,
        ),
      );
    }

    if (planType == PlanType.free) {
      return const SizedBox.shrink(); // No button for the free plan
    }

    return ElevatedButton(
      onPressed: canUpgrade ? () => onSelectPlan(planType) : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor:
            isRecommended ? Theme.of(context).colorScheme.primary : null,
        foregroundColor:
            isRecommended ? Theme.of(context).colorScheme.onPrimary : null,
      ),
      child: Text(
        buttonText ?? (canUpgrade ? 'Fazer Upgrade' : 'Não disponível'),
      ),
    );
  }
}
