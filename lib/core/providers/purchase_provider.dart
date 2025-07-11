import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final purchaseControllerProvider =
    StateNotifierProvider<PurchaseController, PurchaseState>(
      (ref) => PurchaseController(),
    );

class PurchaseController extends StateNotifier<PurchaseState> {
  PurchaseController() : super(PurchaseState.initial());

  Future<void> loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isPremium = prefs.getBool('isPremiumUser') ?? false;

    state = state.copyWith(isPremium: isPremium);
  }

  Future<void> markAsPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremiumUser', true);

    state = state.copyWith(isPremium: true);
  }

  Future<void> resetPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isPremiumUser');

    state = state.copyWith(isPremium: false);
  }

  void setError(String? message) {
    state = state.copyWith(errorMessage: message);
  }
}

class PurchaseState {
  final bool isPremium;
  final String? errorMessage;

  const PurchaseState({required this.isPremium, this.errorMessage});

  factory PurchaseState.initial() => const PurchaseState(isPremium: false);

  PurchaseState copyWith({bool? isPremium, String? errorMessage}) {
    return PurchaseState(
      isPremium: isPremium ?? this.isPremium,
      errorMessage: errorMessage,
    );
  }
}
