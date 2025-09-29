import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/accessibility/accessibility_provider.dart';

class AccessibilitySettingsPage extends ConsumerWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityProvider);
    final notifier = ref.read(accessibilityProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações de Acessibilidade')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Alto Contraste'),
            subtitle: const Text('Aplica um tema com cores mais distintas.'),
            value: settings.highContrast,
            onChanged: (bool value) {
              notifier.toggleHighContrast(value);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Texto em Negrito'),
            subtitle: const Text(
              'Deixa todo o texto do aplicativo em negrito.',
            ),
            value: settings.boldText,
            onChanged: (bool value) {
              notifier.toggleBoldText(value);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Tamanho da Fonte'),
            subtitle: Text(
              'Escala atual: ${settings.fontScale.toStringAsFixed(1)}x',
            ),
          ),
          Slider(
            value: settings.fontScale,
            min: 0.8,
            max: 2.0,
            divisions: 12,
            label: settings.fontScale.toStringAsFixed(1),
            onChanged: (double value) {
              notifier.setFontScale(value);
            },
          ),
        ],
      ),
    );
  }
}
