import 'package:go_router/go_router.dart';
import 'package:intelliresume/presentation/notifiers/router_notify.dart';
import '../../services/auth_service.dart';
import '../presentation/pages.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupPage()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
      GoRoute(path: '/payment', builder: (_, __) => const PaymentPage()),
      GoRoute(
        path: '/form',
        builder: (_, __) => const ResumeFormPage(),
        routes: [
          GoRoute(
            path: 'preview',
            builder: (_, state) {
              final args = state.extra as Map<String, dynamic>;
              return ResumePreviewPage(
                about: args['about'],
                experiences: args['experiences'],
                educations: args['educations'],
                skills: args['skills'],
                socials: args['socials'],
              );
            },
          ),
          GoRoute(path: 'history', builder: (_, __) => const HistoryPage()),
        ],
      ),
    ],
    redirect: (ctx, state) {
      final logged = AuthService.instance.currentUser != null;
      final loggingIn = state.path == '/login' || state.path == '/signup';
      if (!logged && !loggingIn) return '/login';
      if (logged && loggingIn) return '/form';
      return null;
    },
    refreshListenable: RouterNotifier(AuthService.instance),
  );
}
