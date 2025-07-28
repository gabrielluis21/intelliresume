import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum PlanType { free, premium, pro }

final purchaseControllerProvider =
    StateNotifierProvider<PurchaseController, PurchaseState>((ref) {
      return PurchaseController();
    });

class PurchaseController extends StateNotifier<PurchaseState> {
  PurchaseController() : super(PurchaseState.initial());

  Future<void> loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final planName = prefs.getString('currentPlan') ?? 'free';
    final plan = PlanType.values.firstWhere(
      (e) => e.toString().split('.').last == planName,
      orElse: () => PlanType.free,
    );

    state = state.copyWith(currentPlan: plan);
  }

  Future<void> updatePlan(PlanType newPlan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentPlan', newPlan.toString().split('.').last);

    state = state.copyWith(currentPlan: newPlan);
  }

  void setError(String? message) {
    state = state.copyWith(error: message);
  }

  Future<bool> initiatePurchase({
    required String primaryUrl,
    required String fallbackUrl,
    required Future<bool?> Function(String title, String content)
    showFallbackDialog,
  }) async {
    final primaryUri = Uri.parse(primaryUrl);

    try {
      if (await canLaunchUrl(primaryUri)) {
        await launchUrl(primaryUri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        throw Exception('Primary provider unavailable');
      }
    } catch (_) {
      final useFallback =
          await showFallbackDialog(
            'Pagamento indisponível',
            'Deseja tentar com um método alternativo?',
          ) ??
          false;

      if (useFallback) {
        final fallbackUri = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
          return true;
        }
      }
    }
    return false;
  }

  Future<void> verifyPurchaseStatus() async {
    // NOTA: Um delay fixo não é confiável. A solução ideal envolve um backend
    // com webhooks do provedor de pagamento que atualiza o status do usuário
    // em um banco de dados (ex: Firestore). O app então ouviria essas
    // atualizações em tempo real.
    await Future.delayed(const Duration(seconds: 5));

    final prefs = await SharedPreferences.getInstance();
    final isPro = prefs.getBool('isProUser') ?? false;
    if (isPro) await updatePlan(PlanType.premium);
  }
}

class PurchaseState {
  final PlanType currentPlan;
  final String? error;

  bool get isPremium =>
      currentPlan == PlanType.premium || currentPlan == PlanType.pro;

  bool get isPro => currentPlan == PlanType.pro;

  const PurchaseState({required this.currentPlan, this.error});

  factory PurchaseState.initial() =>
      const PurchaseState(currentPlan: PlanType.free);

  PurchaseState copyWith({PlanType? currentPlan, String? error}) {
    return PurchaseState(
      currentPlan: currentPlan ?? this.currentPlan,
      error: error,
    );
  }
}
