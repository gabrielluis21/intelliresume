import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/data/data_provider.dart';
import 'package:intelliresume/core/providers/user_preferences_provider.dart'; // New import
import 'package:intelliresume/generated/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // O AppBar será fornecido pelo LayoutTemplate
      body: ListView(
        children: [
          _SectionTitle(title: l10n.manageAccount),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.manageAccount),
            subtitle: Text(l10n.manageAccountSubtitle),
            onTap: () => context.goNamed('edit-profile'),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l10n.changePassword),
            onTap: () {
              // TODO: Implementar diálogo/página de alteração de senha
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.notImplemented)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: Text(l10n.manageSubscription),
            subtitle: Text(l10n.manageSubscriptionSubtitle),
            onTap: () => context.goNamed('buy'),
          ),
          _SectionTitle(title: l10n.appearanceAndBehavior),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l10n.theme),
            onTap: () => _showThemeDialog(context, ref, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.language),
            onTap: () => _showLanguageDialog(context, ref, l10n),
          ),
          _SectionTitle(title: l10n.accessibility),
          _buildAccessibilitySettings(context, ref, l10n),
          _SectionTitle(title: l10n.aboutAndSupport),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.helpCenter),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.termsOfService),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacyPolicy),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: Text(l10n.licenses),
            onTap: () => showLicensePage(context: context),
          ),
          const Divider(height: 32),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
            title: Text(
              l10n.logout,
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
              l10n.deleteAccount,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () {
              // TODO: Implementar diálogo de confirmação e lógica de exclusão
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.notImplemented)));
            },
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final userPreferences = ref.watch(userPreferencesNotifierProvider);
    final notifier = ref.read(userPreferencesNotifierProvider.notifier);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.selectTheme),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(l10n.light),
                  value: ThemeMode.light,
                  groupValue: userPreferences.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.setThemeMode(value);
                    }
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.dark),
                  value: ThemeMode.dark,
                  groupValue: userPreferences.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.setThemeMode(value);
                    }
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.systemDefault),
                  value: ThemeMode.system,
                  groupValue: userPreferences.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.setThemeMode(value);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final userPreferences = ref.watch(userPreferencesNotifierProvider);
    final notifier = ref.read(userPreferencesNotifierProvider.notifier);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.selectLanguageTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String?>(
                  title: Text(l10n.systemDefault),
                  value: null,
                  groupValue: userPreferences.languageCode,
                  onChanged: (value) {
                    notifier.setLanguage(value);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String?>(
                  title: Text(l10n.portuguese),
                  value: 'pt',
                  groupValue: userPreferences.languageCode,
                  onChanged: (value) {
                    notifier.setLanguage(value);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String?>(
                  title: Text(l10n.english),
                  value: 'en',
                  groupValue: userPreferences.languageCode,
                  onChanged: (value) {
                    notifier.setLanguage(value);
                    Navigator.of(context).pop();
                  },
                ),
                // Add other supported languages here
              ],
            ),
          ),
    );
  }

  Widget _buildAccessibilitySettings(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final userPreferences = ref.watch(userPreferencesNotifierProvider);
    final notifier = ref.read(userPreferencesNotifierProvider.notifier);

    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.contrast),
          title: Text(l10n.highContrast),
          value: userPreferences.highContrast,
          onChanged: (bool value) => notifier.setHighContrast(value),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.format_bold),
          title: Text(l10n.boldText),
          value: userPreferences.boldText,
          onChanged: (bool value) => notifier.setBoldText(value),
        ),
        ListTile(
          leading: const Icon(Icons.format_size),
          title: Text(l10n.fontSize),
          subtitle: Text(
            '${l10n.scale} ${userPreferences.fontSizeScale.toStringAsFixed(1)}x',
          ),
        ),
        Slider(
          value: userPreferences.fontSizeScale,
          min: 0.8,
          max: 2.0,
          divisions: 12,
          label: userPreferences.fontSizeScale.toStringAsFixed(1),
          onChanged: (double value) => notifier.setFontSizeScale(value),
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
