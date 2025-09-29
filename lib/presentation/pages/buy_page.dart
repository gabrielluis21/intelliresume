import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/purchages/purchase_provider.dart';

class BuyPage extends ConsumerWidget {
  const BuyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseState = ref.watch(purchaseControllerProvider);

    ref.listen<PurchaseState>(purchaseControllerProvider, (previous, next) {
      if (next.isPremium) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plano Premium ativado com sucesso!')),
        );
      } else if (next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Seja Premium')),
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
            const ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Geração de currículos em lote com IA'),
            ),
            const ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Modelos exclusivos de CV'),
            ),
            const ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Traduções automáticas profissionais'),
            ),
            const ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Mais armazenamento e histórico'),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_open),
              label: Text(
                purchaseState.isProcessing ? 'Processando...' : 'Assinar Agora',
              ),
              onPressed:
                  purchaseState.isProcessing
                      ? null
                      : () => _initiatePurchase(context, ref),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _initiatePurchase(BuildContext context, WidgetRef ref) async {
    final purchaseController = ref.read(purchaseControllerProvider.notifier);
    await purchaseController.initiatePurchase(
      primaryUrl: 'https://buy.stripe.com/eVq4gAa4U4GoeNO9R1cwg00',
      fallbackUrl: 'https://mpago.la/2NYeBna',
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
  }
}
