import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/routes/app_routes.dart';
import 'web_landing_page.dart'; // Nova página para web

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
    // Redirecionamento automático apenas para mobile
    if (!kIsWeb) {
      Future.delayed(const Duration(seconds: 3), () {
        ref.read(routerProvider).goNamed('login');
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Exibir landing page para web
    if (!kIsWeb) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app-logo',
                  child: Image.asset(
                    'images/logo.png', // Substituir pelo seu asset
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _animation,
                  child: Text(
                    'IntelliResume',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const WebLandingPage();
    // SplashScreen animada para mobile
  }
}
