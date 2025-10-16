import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/accessibility/accessibility_provider.dart';
import 'package:intelliresume/core/providers/data/data_provider.dart';
import 'package:intelliresume/core/providers/languages/locale_provider.dart';
import 'package:intelliresume/core/providers/theme/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // O AppBar será fornecido pelo LayoutTemplate
      body: ListView(
        children: [
          const _SectionTitle(title: 'Conta'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Gerenciar Conta'),
            subtitle: const Text('Altere suas informações de perfil'),
            onTap: () => context.goNamed('edit-profile'),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Alterar Senha'),
            onTap: () {
              // TODO: Implementar diálogo/página de alteração de senha
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade a ser implementada.'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: const Text('Gerenciar Assinatura'),
            subtitle: const Text('Veja os detalhes do seu plano'),
            onTap: () => context.goNamed('buy'),
          ),
          const _SectionTitle(title: 'Aparência e Comportamento'),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Tema'),
            onTap: () => _showThemeDialog(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Idioma'),
            onTap: () => _showLanguageDialog(context, ref),
          ),
          const _SectionTitle(title: 'Acessibilidade'),
          _buildAccessibilitySettings(context, ref),
          const _SectionTitle(title: 'Sobre e Suporte'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Central de Ajuda (FAQ)'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Termos de Serviço'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Política de Privacidade'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('Licenças'),
            onTap: () => showLicensePage(context: context),
          ),
          const Divider(height: 32),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
            title: Text(
              'Sair (Logout)',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: () => ref.read(signOutUseCaseProvider).call(),
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Excluir Conta',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () {
              // TODO: Implementar diálogo de confirmação e lógica de exclusão
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade a ser implementada.'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Selecionar Tema'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Claro'),
                  value: ThemeMode.light,
                  groupValue: currentTheme,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeProvider.notifier).setThemeMode(value);
                    }
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Escuro'),
                  value: ThemeMode.dark,
                  groupValue: currentTheme,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeProvider.notifier).setThemeMode(value);
                    }
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Padrão do Sistema'),
                  value: ThemeMode.system,
                  groupValue: currentTheme,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeProvider.notifier).setThemeMode(value);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Selecionar Idioma'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<Locale>(
                  title: const Text('🇧🇷 Português (Brasil)'),
                  value: const Locale('pt'),
                  groupValue: currentLocale,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(localeProvider.notifier).state = value;
                    }
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<Locale>(
                  title: const Text('🇺🇸 English'),
                  value: const Locale('en'),
                  groupValue: currentLocale,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(localeProvider.notifier).state = value;
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildAccessibilitySettings(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityProvider);
    final notifier = ref.read(accessibilityProvider.notifier);

    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.contrast),
          title: const Text('Modo de Alto Contraste'),
          value: settings.highContrast,
          onChanged: (bool value) => notifier.toggleHighContrast(value),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.format_bold),
          title: const Text('Texto em Negrito'),
          value: settings.boldText,
          onChanged: (bool value) => notifier.toggleBoldText(value),
        ),
        ListTile(
          leading: const Icon(Icons.format_size),
          title: const Text('Tamanho da Fonte'),
          subtitle: Text('Escala: ${settings.fontScale.toStringAsFixed(1)}x'),
        ),
        Slider(
          value: settings.fontScale,
          min: 0.8,
          max: 2.0,
          divisions: 12,
          label: settings.fontScale.toStringAsFixed(1),
          onChanged: (double value) => notifier.setFontScale(value),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
