import 'package:flutter_riverpod/flutter_riverpod.dart';

final accessibilityProvider =
    StateNotifierProvider<AccessibilityService, AccessibilityState>(
      (ref) => AccessibilityService(),
    );

class AccessibilityState {
  final bool highContrast;
  final bool reduceMotion;
  final bool readerMode;

  const AccessibilityState({
    this.highContrast = false,
    this.reduceMotion = false,
    this.readerMode = false,
  });

  AccessibilityState copyWith({
    bool? highContrast,
    bool? reduceMotion,
    bool? readerMode,
  }) {
    return AccessibilityState(
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      readerMode: readerMode ?? this.readerMode,
    );
  }
}

class AccessibilityService extends StateNotifier<AccessibilityState> {
  AccessibilityService() : super(const AccessibilityState());

  void toggleHighContrast() =>
      state = state.copyWith(highContrast: !state.highContrast);
  void toggleReduceMotion() =>
      state = state.copyWith(reduceMotion: !state.reduceMotion);
  void toggleReaderMode() =>
      state = state.copyWith(readerMode: !state.readerMode);
}
