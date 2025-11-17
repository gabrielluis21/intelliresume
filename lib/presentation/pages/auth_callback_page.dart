import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCallbackPage extends ConsumerStatefulWidget {
  final String? token;
  final String? next;

  const AuthCallbackPage({super.key, this.token, this.next});

  @override
  ConsumerState<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends ConsumerState<AuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    _handleSignIn();
  }

  Future<void> _handleSignIn() async {
    final token = widget.token;
    if (token == null || token.isEmpty) {
      // Handle error: no token provided
      _showErrorAndRedirect('Nenhum token de autenticação fornecido.');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithCustomToken(token);
      // On successful sign-in, the auth state listener in the app will trigger.
      // We can now redirect to the final destination.
      final nextUrl = widget.next ?? '/dashboard';
      if (mounted) {
        context.go(nextUrl);
      }
    } catch (e) {
      // Handle error: token is invalid or expired
      _showErrorAndRedirect('Falha ao autenticar: ${e.toString()}');
    }
  }

  void _showErrorAndRedirect(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
      // Redirect to login page after showing the error
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while the sign-in process is happening.
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Finalizando login...'),
          ],
        ),
      ),
    );
  }
}
