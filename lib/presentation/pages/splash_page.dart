// lib/pages/splash_page.dart

import 'dart:async';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../core/utils/app_localizations.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Delay de 2s e depois navegar
    Timer(const Duration(seconds: 2), _goNext);
  }

  void _goNext() {
    final isMobile =
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
    if (!isMobile) {
      // em Web, vamos direto para o form (ou splash não aparece)
      AppRoutes.router.pushReplacementNamed('/form');
      return;
    }
    final user = AuthService.instance.currentUser;
    AppRoutes.router.pushReplacementNamed(user != null ? '/form' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.article, size: 72, color: primary),
            const SizedBox(height: 16),
            Text(
              t.appTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: primary),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
