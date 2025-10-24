import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/languages/locale_provider.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:intelliresume/presentation/widgets/pricing/pricing_card.dart';

class PricingSectionWidget extends ConsumerWidget {
  final PlanType? currentUserPlan;
  final String? buttonText;
  final Function(PlanType)? onSelectPlan;

  const PricingSectionWidget({
    super.key,
    this.currentUserPlan,
    this.onSelectPlan,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = ref.watch(currencyFormatProvider);

    const priceFree = 0.0;
    const pricePremium = 29.90;
    const pricePro = 49.90;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 500,
              child: PricingCard(
                title: 'Free',
                price: currencyFormat.format(priceFree),
                description: 'Para começar a criar seu currículo.',
                features: const [
                  '1 currículo',
                  'Modelos básicos',
                  'Exportação em PDF',
                ],
                planType: PlanType.free,
                currentUserPlan: currentUserPlan,
                onSelectPlan: onSelectPlan ?? (plan) {},
                buttonText: buttonText,
              ),
            ),
            SizedBox(
              width: 300,
              height: 500,
              child: PricingCard(
                title: 'Premium',
                price: '${currencyFormat.format(pricePremium)}/mês',
                description: 'Desbloqueie recursos avançados.',
                features: const [
                  'Currículos ilimitados',
                  'Modelos Premium',
                  'Assistente de IA',
                  'Tradução automática',
                ],
                planType: PlanType.premium,
                currentUserPlan: currentUserPlan,
                onSelectPlan: onSelectPlan ?? (plan) {},
                buttonText: buttonText,
              ),
            ),
            SizedBox(
              width: 300,
              height: 500,
              child: PricingCard(
                title: 'Pro',
                price: '${currencyFormat.format(pricePro)}/mês',
                description: 'Para profissionais exigentes.',
                features: const [
                  'Tudo do Premium',
                  'Modo Estúdio',
                  'Análise de Vagas',
                  'Suporte prioritário',
                ],
                planType: PlanType.pro,
                currentUserPlan: currentUserPlan,
                isRecommended: true,
                onSelectPlan: onSelectPlan ?? (plan) {},
                buttonText: buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
