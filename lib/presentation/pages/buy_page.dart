import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/purchases/purchase_provider.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/presentation/widgets/layout_template.dart';
import 'package:intelliresume/presentation/widgets/pricing/pricing_section_widget.dart';

class BuyPage extends ConsumerWidget {
  const BuyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen<PurchaseState>(purchaseControllerProvider, (previous, next) {
      if (next.isPremium) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.buyPage_premiumSuccess)));
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.buyPage_genericError(next.error!))),
        );
      }
    });

    return LayoutTemplate(
      selectedIndex: 4, // Index for BuyPage in the side menu
      child: userProfile.when(
        data: (user) {
          return PricingSectionWidget(
            currentUserPlan: user?.plan ?? PlanType.free,
            onSelectPlan: (plan) {
              // For now, we only support upgrading to premium
              if (plan == PlanType.premium) {
                ref
                    .read(purchaseControllerProvider.notifier)
                    .initiatePurchase();
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Text(l10n.buyPage_genericError(error.toString())),
            ),
      ),
    );
  }
}
