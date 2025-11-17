import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/user_preferences_provider.dart'; // New import
import 'core/routes/app_routes.dart';
import 'core/themes.dart';
import 'package:intelliresume/generated/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final userPreferences = ref.watch(
      userPreferencesNotifierProvider,
    ); // Use new provider

    final textScaler = TextScaler.linear(userPreferences.fontSizeScale);

    final activeLightTheme =
        userPreferences.highContrast
            ? AppTheme.highContrastTheme(textScaler)
            : AppTheme.lightTheme(textScaler);

    final activeDarkTheme =
        userPreferences.highContrast
            ? AppTheme.highContrastTheme(textScaler)
            : AppTheme.darkTheme(textScaler);

    return MaterialApp.router(
      title: 'IntelliResume',
      debugShowCheckedModeBanner: false,
      theme: activeLightTheme,
      darkTheme: activeDarkTheme,
      themeMode:
          userPreferences.themeMode, // Use themeMode from userPreferences
      locale:
          userPreferences.languageCode != null
              ? Locale(userPreferences.languageCode!)
              : null, // Use locale from userPreferences
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(userPreferences.fontSizeScale),
            boldText: userPreferences.boldText,
          ),
          child: child!,
        );
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    );
  }
}
