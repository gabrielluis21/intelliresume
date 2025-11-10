import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/notifiers/router_notify.dart';
import 'package:intelliresume/data/datasources/remote/auth_resume_ds.dart';

import 'package:intelliresume/presentation/widgets/layout_template.dart';
import '../../presentation/pages.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final analyticsProvider = Provider<FirebaseAnalytics>((ref) {
  return FirebaseAnalytics.instance;
});

final analyticsObserverProvider = Provider<FirebaseAnalyticsObserver>((ref) {
  final analytics = ref.watch(analyticsProvider);
  return FirebaseAnalyticsObserver(analytics: analytics);
});

final routerProvider = Provider<GoRouter>((ref) {
  final analyticsObserver = ref.watch(analyticsObserverProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    observers: [analyticsObserver],
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
        name: 'buy',
        path: '/buy',
        builder: (context, state) => const BuyPage(),
      ),
      GoRoute(
        name: 'editor-new',
        path: '/editor/new',
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LayoutTemplate(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'home',
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'profile',
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'history',
                path: '/history',
                builder: (context, state) => const HistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'settings',
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (ctx, state) {
      final logged = AuthService.instance.currentUser != null;

      // Define public paths that can be accessed without authentication.
      final publicPaths = ['/login', '/signup', '/'];
      final isPublicPath = publicPaths.contains(state.uri.path);

      // If the user is not logged in and is trying to access a non-public page,
      // redirect them to the landing page ('/').
      if (!logged && !isPublicPath) {
        return '/';
      }

      // If the user is logged in and tries to access a public page (like login),
      // redirect them to the home page.
      if (logged && isPublicPath) {
        return '/home';
      }

      // No redirect needed.
      return null;
    },
    refreshListenable: RouterNotifier(AuthService.instance),
  );
});
