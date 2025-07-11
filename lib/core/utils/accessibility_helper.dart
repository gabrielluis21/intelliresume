import 'package:flutter/material.dart';

/// A helper class for accessibility and semantics
class AccessibilityHelper {
  /// Wraps a widget with semantic information
  static Widget wrapWithSemantics({
    required Widget child,
    required String label,
    bool isButton = false,
    bool isImage = false,
    bool enabled = true,
    bool excludeSemantics = false,
  }) {
    return Semantics(
      label: label,
      button: isButton,
      image: isImage,
      enabled: enabled,
      excludeSemantics: excludeSemantics,
      child: child,
    );
  }

  /// Creates a semantic button
  static Widget semanticButton({
    required String label,
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: ElevatedButton(onPressed: onPressed, child: child),
    );
  }

  /// Accessible Image
  static Widget semanticImage({
    required String label,
    required ImageProvider image,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return Semantics(
      image: true,
      label: label,
      child: Image(image: image, fit: fit, width: width, height: height),
    );
  }

  /// Creates a TextField with semantic label
  static Widget semanticTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    bool obscureText = false,
  }) {
    return Semantics(
      label: label,
      textField: true,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(hintText: hintText ?? label),
      ),
    );
  }
}
