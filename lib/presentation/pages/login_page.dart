import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/errors/exceptions.dart';
import 'package:intelliresume/core/providers/data/data_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  bool _loading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  Future<void> _forgetPassword() async {
    _formKey.currentState!.save();
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _errorMessage =
            'Por favor, insira um e-mail válido para redefinir a senha.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(sendPasswordResetUseCaseProvider).call(email: email);
      if (mounted) {
        setState(() {
          _errorMessage = 'Um e-mail de redefinição foi enviado para $email.';
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(signInUseCaseProvider)
          .call(email: email, password: password);

      if (mounted) context.goNamed('home');
    } catch (e) {
      if (mounted) {
        String message;
        if (e is AppException) {
          // This is our custom exception! We can use the key to get a
          // user-friendly, translated message.
          switch (e.key) {
            case 'error_auth_user_not_found':
              message = AppLocalizations.of(context)!.error_auth_user_not_found;
              break;
            case 'error_auth_wrong_password':
              message = AppLocalizations.of(context)!.error_auth_wrong_password;
              break;
            case 'error_auth_invalid_email':
              message = AppLocalizations.of(context)!.error_auth_invalid_email;
              break;
            default:
              message = AppLocalizations.of(context)!.error_auth_generic;
          }
        } else {
          // This is an unexpected error. Show a generic message.
          message = AppLocalizations.of(context)!.anErrorOccurred;
        }
        setState(() {
          _errorMessage = message;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                        width: 80,
                        semanticLabel: 'Logo do IntelliResume',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.login,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bem-vindo de volta! Acesse sua conta.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        key: const Key('login_email_field'),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.email,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            (v) =>
                                (v?.contains('@') == true)
                                    ? null
                                    : AppLocalizations.of(
                                      context,
                                    )!.invalidEmail,
                        onSaved: (v) => email = v!.trim(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('login_password_field'),
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.password,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            tooltip:
                                _obscurePassword
                                    ? 'Mostrar senha'
                                    : 'Ocultar senha',
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator:
                            (v) =>
                                (v != null && v.length >= 6)
                                    ? null
                                    : AppLocalizations.of(
                                      context,
                                    )!.passwordTooShort,
                        onSaved: (v) => password = v!,
                      ),
                      const SizedBox(height: 24),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _loading ? null : _forgetPassword,
                            child: Text(
                              AppLocalizations.of(context)!.forgetPassword,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          key: const Key('login_button'),
                          onPressed: _loading ? null : _login,
                          child:
                              _loading
                                  ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                  : Text(
                                    AppLocalizations.of(context)!.login,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.goNamed('signup'),
                        child: Text(
                          'Não tem uma conta? ${AppLocalizations.of(context)!.signup}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
