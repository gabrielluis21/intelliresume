import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// 1. Estado para o status da assinatura
class PurchaseState {
  final bool isPremium;
  final bool isProcessing;
  final String? error;

  PurchaseState({
    this.isPremium = false,
    this.isProcessing = false,
    this.error,
  });

  PurchaseState copyWith({bool? isPremium, bool? isProcessing, String? error}) {
    return PurchaseState(
      isPremium: isPremium ?? this.isPremium,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error ?? this.error,
    );
  }
}

// 2. Notifier para gerenciar a lógica de compra
class PurchaseController extends StateNotifier<PurchaseState> {
  PurchaseController() : super(PurchaseState());

  Future<bool> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  Future<bool> initiatePurchase({
    required String primaryUrl,
    required String fallbackUrl,
    required Future<bool?> Function(String, String) showFallbackDialog,
  }) async {
    state = state.copyWith(isProcessing: true);
    bool success = false;

    try {
      success = await _launchURL(primaryUrl);
      if (!success) {
        final useFallback = await showFallbackDialog(
          'Ops! Algo deu errado',
          'Não conseguimos abrir o link de pagamento principal. Deseja tentar com uma opção alternativa?',
        );
        if (useFallback == true) {
          success = await _launchURL(fallbackUrl);
        }
      }
    } finally {
      state = state.copyWith(isProcessing: false);
    }
    return success;
  }

  // Simula a verificação do status da compra (em produção, use webhooks)
  Future<void> verifyPurchaseStatus() async {
    state = state.copyWith(isProcessing: true);
    // Simula uma chamada de rede para o backend
    await Future.delayed(const Duration(seconds: 2));
    // Em um app real, o backend confirmaria o pagamento e você atualizaria o estado
    state = state.copyWith(isPremium: true, isProcessing: false);
  }
}

// 3. Provider para acessar o controller e o estado
final purchaseControllerProvider =
    StateNotifierProvider<PurchaseController, PurchaseState>(
      (ref) => PurchaseController(),
    );
