import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/presentation/widgets/layout_template.dart';
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
        name: 'signup',
        path: '/signup',
        builder: (context, state) => const SignupPage(),
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
        name: 'editor-new',
        path: '/editor',
        builder: (context, state) => const ResumeFormPage(resumeId: 'new'),
      ),
      GoRoute(
        name: 'editor',
        path: '/editor/:resumeId',
        builder: (context, state) {
          final resumeId = state.pathParameters['resumeId']!;
          return ResumeFormPage(resumeId: resumeId);
        },
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
        name: 'history',
        path: '/history',
        builder:
            (context, state) =>
                LayoutTemplate(selectedIndex: 2, child: const HistoryPage()),
      ),
      GoRoute(
        name: 'settings',
        path: '/settings',
        builder:
            (context, state) => LayoutTemplate(
              selectedIndex: 4,
              child: const SettingsPage(), // Implemente esta página
            ),
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
