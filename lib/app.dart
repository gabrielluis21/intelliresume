import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_routes.dart';
import 'core/themes.dart';
import 'core/utils/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'IntelliResume',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      localeResolutionCallback: _localeResolution,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  Locale _localeResolution(Locale? locale, Iterable<Locale> supported) {
    if (locale == null) return supported.first;
    for (final l in supported) {
      if (l.languageCode == locale.languageCode) return l;
    }
    return supported.first;
  }
}
