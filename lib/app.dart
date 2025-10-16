import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/accessibility/accessibility_provider.dart';
import 'package:intelliresume/core/providers/languages/locale_provider.dart';
import 'package:intelliresume/core/providers/theme/theme_provider.dart';
import 'core/routes/app_routes.dart';
import 'core/themes.dart';
import 'core/utils/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final accessibilitySettings = ref.watch(accessibilityProvider);
    final themeMode = ref.watch(themeProvider);

    final activeLightTheme =
        accessibilitySettings.highContrast ? highContrastTheme : lightTheme;
    final activeDarkTheme =
        accessibilitySettings.highContrast ? highContrastTheme : darkTheme;

    return MaterialApp.router(
      title: 'IntelliResume',
      debugShowCheckedModeBanner: false,
      theme: activeLightTheme,
      darkTheme: activeDarkTheme,
      themeMode: themeMode,
      locale: locale,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(accessibilitySettings.fontScale),
            boldText: accessibilitySettings.boldText,
          ),
          child: child!,
        );
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => 'IntelliResume',
    );
  }
}
