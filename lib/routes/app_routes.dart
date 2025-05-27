import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/presentation/pages/home_page.dart';
import '../presentation/pages.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: kIsWeb ? '/login' : '/',
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
        name: 'payment',
        path: '/payment',
        builder: (context, state) => const PaymentPage(),
      ),
      GoRoute(
        name: 'form',
        path: '/form',
        builder: (context, state) => const ResumeFormPage(),
      ),
      GoRoute(
        name: 'history',
        path: '/history',
        builder: (context, state) => const HistoryPage(),
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    /*  redirect: (ctx, state) {
      final logged = AuthService.instance.currentUser != null;
      final loggingIn = state.path == '/login' || state.path == '/signup';
      if (!logged && !loggingIn) return '/login';
      if (logged && loggingIn) return '/form';
      return null;
    },
    refreshListenable: RouterNotifier(AuthService.instance), */
  );
}
