import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:intelliresume/services/payment_service.dart';

// 1. Provider para o serviço de pagamento
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService.instance;
});

// 2. Estado para o status da assinatura
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
      error: error, // Permite limpar o erro passando null
    );
  }
}

// 3. Notifier para gerenciar a lógica de compra
class PurchaseController extends StateNotifier<PurchaseState> {
  final PaymentService _paymentService;

  PurchaseController(this._paymentService) : super(PurchaseState());

  void updateUserProfile(UserProfile? profile) {
    if (profile != null) {
      state = state.copyWith(isPremium: profile.plan == PlanType.premium);
    }
  }

  Future<void> initiatePurchase() async {
    state = state.copyWith(isProcessing: true, error: null);
    try {
      await _paymentService.purchasePremium();
    } catch (e) {
      state = state.copyWith(
        error: 'Falha ao iniciar o processo de pagamento: $e',
      );
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }
}

// 4. Provider para acessar o controller e o estado
final purchaseControllerProvider =
    StateNotifierProvider<PurchaseController, PurchaseState>((ref) {
      final paymentService = ref.watch(paymentServiceProvider);
      final controller = PurchaseController(paymentService);

      // Ouve as mudanças no perfil do usuário e atualiza o estado da compra
      ref.listen<AsyncValue<UserProfile?>>(userProfileProvider, (
        previous,
        next,
      ) {
        controller.updateUserProfile(next.value);
      });

      return controller;
    });
