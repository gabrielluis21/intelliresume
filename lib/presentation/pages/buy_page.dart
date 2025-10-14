import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/purchases/purchase_provider.dart';

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
    await ref.read(purchaseControllerProvider.notifier).initiatePurchase();
  }
}
