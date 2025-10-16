import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/domain/entities/accessibility_settings.dart';

class AccessibilityNotifier extends StateNotifier<AccessibilitySettings> {
  AccessibilityNotifier() : super(const AccessibilitySettings());

  void setFontScale(double scale) {
    state = state.copyWith(fontScale: scale);
  }

  void toggleHighContrast(bool isEnabled) {
    state = state.copyWith(highContrast: isEnabled);
  }

  void toggleBoldText(bool isEnabled) {
    state = state.copyWith(boldText: isEnabled);
  }
}

final accessibilityProvider =
    StateNotifierProvider<AccessibilityNotifier, AccessibilitySettings>((ref) {
      return AccessibilityNotifier();
    });

/// Provider para gerenciar o estado do Modo Libras.
final librasModeProvider = StateProvider<bool>((ref) => false);
