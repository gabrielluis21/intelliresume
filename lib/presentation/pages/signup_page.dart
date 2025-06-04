import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/data/datasources/remote/auth_resume_ds.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/app_localizations.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});
  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '', confirm = '';
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Validação de igualdade de senhas
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).passwordsDontMatch),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.instance.signUp(email: email, password: password);
      ref.watch(routerProvider).goNamed('home');
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.signup)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.signup,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    // Campo de email
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: t.email,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return t.fieldRequired;
                        if (!v.contains('@')) return t.invalidEmail;
                        return null;
                      },
                      onSaved: (v) => email = v!.trim(),
                    ),
                    const SizedBox(height: 16),
                    // Campo de senha
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: t.password,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (v) {
                        if (v == null || v.isEmpty) return t.fieldRequired;
                        if (v.length < 6) return t.passwordTooShort;
                        return null;
                      },
                      onSaved: (v) => password = v!,
                    ),
                    const SizedBox(height: 16),
                    // Campo de confirmação de senha
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: t.confirmPassword,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed:
                              () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                        ),
                      ),
                      obscureText: _obscureConfirm,
                      validator: (v) {
                        if (v == null || v.isEmpty) return t.fieldRequired;
                        return null;
                      },
                      onSaved: (v) => confirm = v!,
                    ),
                    const SizedBox(height: 24),
                    // Botão de cadastro
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _signup,
                        child:
                            _loading
                                ? const CircularProgressIndicator.adaptive()
                                : Text(t.signup),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
