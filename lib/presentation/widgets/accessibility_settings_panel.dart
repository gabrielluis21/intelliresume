import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/accessibility_provider.dart';

class AccessibilitySettingsPanel extends ConsumerWidget {
  const AccessibilitySettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accessibilityProvider);
    final controller = ref.read(accessibilityProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acessibilidade',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SwitchListTile(
          title: const Text('Alto contraste'),
          value: state.highContrast,
          onChanged: (_) => controller.toggleHighContrast(),
        ),
        SwitchListTile(
          title: const Text('Reduzir animações'),
          value: state.reduceMotion,
          onChanged: (_) => controller.toggleReduceMotion(),
        ),
        SwitchListTile(
          title: const Text('Modo leitura'),
          value: state.readerMode,
          onChanged: (_) => controller.toggleReaderMode(),
        ),
      ],
    );
  }
}
