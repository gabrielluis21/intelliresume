import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/data/datasources/remote/auth_resume_ds.dart';
import '../../core/utils/app_localizations.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});
  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', password = '', confirm = '';
  String? disabilityInfo;
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _showDisabilityField = false;
  String? _errorMessage;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    if (password != confirm) {
      setState(() {
        _errorMessage = AppLocalizations.of(context).passwordsDontMatch;
        _loading = false;
      });
      return;
    }

    try {
      await AuthService.instance.signUp(
        email: email,
        password: password,
        displayName: name,
        disabilityInfo: disabilityInfo, // <-- Parâmetro agora ativado
      );
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
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                        width: 80,
                        semanticLabel: 'Logo do IntelliResume',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t.signup,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Crie sua conta para começar a usar.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nome Completo',
                          prefixIcon: Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (v) {
                          if (v == null || v.isEmpty) return t.fieldRequired;
                          return null;
                        },
                        onSaved: (v) => name = v!.trim(),
                      ),
                      const SizedBox(height: 16),
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
                      TextFormField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: t.password,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            tooltip: _obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return t.fieldRequired;
                          if (v.length < 6) return t.passwordTooShort;
                          return null;
                        },
                        onSaved: (v) => password = v!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: t.confirmPassword,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                            tooltip: _obscureConfirm ? 'Mostrar senha' : 'Ocultar senha',
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return t.fieldRequired;
                          return null;
                        },
                        onSaved: (v) => confirm = v!,
                      ),
                      const SizedBox(height: 24),
                      // --- CAMPO DE ACESSIBILIDADE ---
                      Semantics(
                        label: 'Opção para informar dados de acessibilidade ou deficiência.',
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Informar dados de acessibilidade?'),
                                Switch(
                                  value: _showDisabilityField,
                                  onChanged: (value) {
                                    setState(() {
                                      _showDisabilityField = value;
                                      if (!value) {
                                        disabilityInfo = null; // Limpa a informação se o usuário desmarcar
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (_showDisabilityField) ...[
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Descrição (opcional)',
                                  prefixIcon: Icon(Icons.accessibility_new),
                                  helperText: 'Ex: Necessito de intérprete de Libras.',
                                ),
                                onSaved: (v) => disabilityInfo = v?.trim(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _signup,
                          child: _loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(t.signup, style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.goNamed('login'),
                        child: Text('Já tem uma conta? ${t.login}'),
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
