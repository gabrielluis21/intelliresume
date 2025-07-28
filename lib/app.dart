import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/locale_provider.dart';
import 'routes/app_routes.dart';
import 'core/themes.dart';
import 'core/utils/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // 1. Ouve as mudanças no provider de locale.
    // Quando o idioma for trocado em qualquer lugar do app,
    // este widget será reconstruído com o novo valor.
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'IntelliResume',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      // 2. Passa o locale do provider diretamente para o MaterialApp.
      // Isso força o Flutter a usar o idioma especificado e a recarregar
      // as traduções do AppLocalizations.
      locale: locale,
      routerConfig: router,
      builder:
          (context, child) => AccessibilityTools(
            enableButtonsDrag: true,
            checkFontOverflows: true,
            checkImageLabels: true,
            buttonsAlignment: ButtonsAlignment.bottomRight,
            child: child,
          ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    );
  }
}
