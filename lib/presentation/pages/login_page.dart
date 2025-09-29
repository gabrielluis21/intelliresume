import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/resume/cv_provider.dart';
import '../../core/providers/user/user_provider.dart';
import '../../data/datasources/remote/auth_resume_ds.dart';
import '../../core/utils/app_localizations.dart';

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

  Future<void> _forgetPassword(String? email) async {
    setState(() {
      _loading = true;
    });
    if (email != null && email.isEmpty) return;
    setState(() {
      _loading = false;
      _errorMessage = 'Preencha o campo email';
    });
    await AuthService.instance.sendPasswordReset(email: email!);
    setState(() {
      _loading = false;
      _errorMessage = 'Um email foi enviado para $email';
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final logged = await AuthService.instance.signIn(
        email: email,
        password: password,
      );

      final userProfileRepository = ref.read(userProfileRepositoryProvider);
      final user = await userProfileRepository.watchProfile(logged.uid).first;
      ref.read(localResumeProvider.notifier).updatePersonalInfo(user);

      if (mounted) context.goNamed('home');
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
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
                        'assets/images/logo.png', // Certifique-se que o caminho está correto
                        height: 80,
                        width: 80,
                        semanticLabel: 'Logo do IntelliResume',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t.login,
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
                        decoration: InputDecoration(
                          labelText: t.email,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            (v) =>
                                (v?.contains('@') == true)
                                    ? null
                                    : t.invalidEmail,
                        onSaved: (v) => email = v!.trim(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: t.password,
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
                                    : t.passwordTooShort,
                        onSaved: (v) => password = v!,
                      ),
                      const SizedBox(height: 24),
                      _errorMessage != null
                          ? Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                          : SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _forgetPassword(email),
                            child: Text(t.forgotPassword),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          child:
                              _loading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                    t.login,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.goNamed('signup'),
                        child: Text('Não tem uma conta? ${t.signup}'),
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
