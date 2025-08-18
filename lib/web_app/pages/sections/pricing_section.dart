import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/purchase_provider.dart';
import 'package:intelliresume/core/utils/app_localizations.dart';

class PricingSection extends ConsumerWidget {
  final GlobalKey pricingKey;
  static const Color _brandBlue = Color(0xFF0D47A1);

  const PricingSection({super.key, required this.pricingKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final purchaseState = ref.watch(purchaseControllerProvider);

    return Container(
      key: pricingKey,
      color: _brandBlue.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          Semantics(
            header: true,
            child: Text(
              AppLocalizations.of(context).plansTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildPlanCard(
                context,
                ref,
                title: AppLocalizations.of(context).planFreeTitle,
                price: 'R\$0,00',
                description: AppLocalizations.of(context).planFreeDetailsShort,
                isPremium: false,
              ),
              _buildPlanCard(
                context,
                ref,
                title: AppLocalizations.of(context).premiumPlan,
                price: 'R\$14,90/mês',
                description:
                    AppLocalizations.of(context).planPremiumDetailsShort,
                isPremium: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String price,
    required String description,
    required bool isPremium,
  }) {
    final purchaseState = ref.watch(purchaseControllerProvider);

    return Semantics(
      label: 'Plano $title por $price. $description',
      child: FocusableActionDetector(
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(description),
              if (isPremium) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      purchaseState.isProcessing
                          ? null
                          : () => _initiatePurchase(context, ref),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: Text(
                    purchaseState.isProcessing
                        ? 'Processando...'
                        : 'Assinar Agora',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initiatePurchase(BuildContext context, WidgetRef ref) async {
    final purchaseController = ref.read(purchaseControllerProvider.notifier);
    final success = await purchaseController.initiatePurchase(
      primaryUrl: 'https://buy.stripe.com/test_abc123456',
      fallbackUrl: 'https://mpago.la/123ABC',
      showFallbackDialog:
          (title, content) => showDialog<bool>(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: Text(title),
                  content: Text(content),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Não, obrigado'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Sim, tentar'),
                    ),
                  ],
                ),
          ),
    );

    if (success) {
      await Future.delayed(const Duration(seconds: 5));
      await purchaseController.verifyPurchaseStatus();
      final isPremium = ref.read(purchaseControllerProvider).isPremium;
      if (isPremium && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plano Premium ativado com sucesso!')),
        );
      }
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível iniciar a compra.')),
      );
    }
  }
}
