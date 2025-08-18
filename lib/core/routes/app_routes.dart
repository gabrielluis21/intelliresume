import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/presentation/widgets/layout_template.dart';
import 'package:pdf/widgets.dart';
import '../../presentation/pages.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: 'splash',
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        name: 'profile',
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        name: 'buy',
        path: '/buy',
        builder: (context, state) => const BuyPage(),
      ),
      GoRoute(
        name: 'form',
        path: '/form',
        builder: (context, state) => const ResumeFormPage(),
        routes: [
          GoRoute(
            name: 'preview',
            path: 'preview',
            builder: (context, state) => const ResumePreviewPage(),
          ),
          GoRoute(
            name: 'preview-pdf',
            path: 'preview-pdf',
            builder:
                (context, state) =>
                    PreviewPdfScreen(pdf: state.extra as Document),
          ),
        ],
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: 'edit-profile',
        path: '/edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/history',
        builder:
            (context, state) => LayoutTemplate(
              selectedIndex: 2,
              child: const HistoryPage(), // Implemente esta página
            ),
      ),
      GoRoute(
        path: '/settings',
        builder:
            (context, state) => LayoutTemplate(
              selectedIndex: 4,
              child: const SettingsPage(), // Implemente esta página
            ),
        routes: [
          GoRoute(
            name: 'accessibility-settings',
            path: 'accessibility',
            builder: (context, state) => const AccessibilitySettingsPage(),
          ),
        ],
      ),
    ],
    /* redirect: (ctx, state) {
      final logged = AuthService.instance.currentUser != null;
      final loggingIn = state.path == '/login' || state.path == '/signup';
      if (!logged && !loggingIn) return '/';
      if (logged && loggingIn) return '/home';
      return null;
    },
    refreshListenable: RouterNotifier(AuthService.instance), */
  );
});
