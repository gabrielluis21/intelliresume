import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/purchase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyPage extends ConsumerWidget {
  const BuyPage({super.key});

  Future<void> _checkProStatus(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final isPro = prefs.getBool('isProUser') ?? false;
    if (isPro) {
      ref
          .read(purchaseControllerProvider.notifier)
          .updatePlan(PlanType.premium);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Versão PREMIUM ativada!')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Versão PRO')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Desbloqueie recursos premium:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('✔️ Geração de currículos em lote com IA'),
            const Text('✔️ Modelos exclusivos de CV'),
            const Text('✔️ Traduções automáticas profissionais'),
            const Text('✔️ Mais armazenamento e histórico'),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_open),
              label: const Text('Comprar com Stripe Checkout'),
              onPressed: () async {
                const stripeUrl =
                    'https://buy.stripe.com/test_abc123456'; // Substitua pelo seu link
                final stripeUri = Uri.parse(stripeUrl);

                try {
                  if (await canLaunchUrl(stripeUri)) {
                    await launchUrl(
                      stripeUri,
                      mode: LaunchMode.externalApplication,
                    );
                    await Future.delayed(const Duration(seconds: 4));
                    _checkProStatus(context, ref);
                  } else {
                    throw Exception('Stripe indisponível');
                  }
                } catch (_) {
                  final retry = await showDialog<bool>(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: const Text('Stripe indisponível'),
                          content: const Text(
                            'Deseja tentar com o Mercado Pago?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Sim'),
                            ),
                          ],
                        ),
                  );

                  if (retry == true) {
                    const mpUrl =
                        'https://mpago.la/123ABC'; // Substitua pelo link gerado no Mercado Pago
                    final mpUri = Uri.parse(mpUrl);

                    if (await canLaunchUrl(mpUri)) {
                      await launchUrl(
                        mpUri,
                        mode: LaunchMode.externalApplication,
                      );
                      await Future.delayed(const Duration(seconds: 4));
                      _checkProStatus(context, ref);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Erro ao abrir o link do Mercado Pago.',
                          ),
                        ),
                      );
                    }
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            if (state.error != null)
              Text(state.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
