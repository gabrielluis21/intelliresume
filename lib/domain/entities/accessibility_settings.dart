import 'package:flutter/foundation.dart';

@immutable
class AccessibilitySettings {
  final double fontScale;
  final bool highContrast;
  final bool boldText;

  const AccessibilitySettings({
    this.fontScale = 1.0,
    this.highContrast = false,
    this.boldText = false,
  });

  AccessibilitySettings copyWith({
    double? fontScale,
    bool? highContrast,
    bool? boldText,
  }) {
    return AccessibilitySettings(
      fontScale: fontScale ?? this.fontScale,
      highContrast: highContrast ?? this.highContrast,
      boldText: boldText ?? this.boldText,
    );
  }
}
