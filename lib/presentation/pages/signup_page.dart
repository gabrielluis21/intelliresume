import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/data/data_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    if (password != confirm) {
      setState(() {
        _errorMessage = l10n.passwordsDontMatch;
        _loading = false;
      });
      return;
    }

    try {
      await ref
          .read(signUpUseCaseProvider)
          .call(
            email: email,
            password: password,
            displayName: name,
            disabilityInfo: disabilityInfo,
          );
      if (mounted) context.goNamed('home');
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                        width: 80,
                        semanticLabel: l10n.login_logoSemanticLabel,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.signup,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        l10n.signup_createAccountPrompt,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        key: const Key('signup_name_field'),
                        decoration: InputDecoration(
                          labelText: l10n.signup_fullNameLabel,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return l10n.fieldRequired;
                          }
                          return null;
                        },
                        onSaved: (v) => name = v!.trim(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('signup_email_field'),
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return l10n.invalidEmail;
                          }
                          if (!v.contains('@')) {
                            return l10n.invalidEmail;
                          }
                          return null;
                        },
                        onSaved: (v) => email = v!.trim(),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        key: const Key('signup_password_field'),
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            tooltip:
                                _obscurePassword
                                    ? l10n.login_showPasswordTooltip
                                    : l10n.login_hidePasswordTooltip,
                            onPressed:
                                () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return l10n.fieldRequired;
                          }
                          if (v.length < 8) {
                            return l10n.passwordTooShort;
                          }
                          return null;
                        },
                        onSaved: (v) => password = v!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('signup_confirm_password_field'),
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: l10n.confirmPass,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            tooltip:
                                _obscureConfirm
                                    ? l10n.login_showPasswordTooltip
                                    : l10n.login_hidePasswordTooltip,
                            onPressed:
                                () => setState(
                                  () => _obscureConfirm = !_obscureConfirm,
                                ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return l10n.fieldRequired;
                          }
                          return null;
                        },
                        onSaved: (v) => confirm = v!,
                      ),
                      const SizedBox(height: 16),
                      // --- CAMPO DE ACESSIBILIDADE ---
                      Semantics(
                        label: l10n.signup_disabilityInfoSemanticLabel,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(l10n.signup_informDisabilityQuestion),
                                ),
                                Switch(
                                  value: _showDisabilityField,
                                  onChanged: (value) {
                                    setState(() {
                                      _showDisabilityField = value;
                                      if (!value) {
                                        disabilityInfo =
                                            null; // Limpa a informação se o usuário desmarcar
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (_showDisabilityField) ...[
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText:
                                      l10n.signup_disabilityDescriptionLabel,
                                  prefixIcon: const Icon(
                                    Icons.accessibility_new,
                                  ),
                                  helperText:
                                      l10n.signup_disabilityDescriptionHelper,
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
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          key: const Key('signup_button'),
                          onPressed: _loading ? null : _signup,
                          child:
                              _loading
                                  ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                  : Text(
                                    l10n.signup,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.goNamed('login'),
                        child: Text('${l10n.login_noAccount} ${l10n.login}'),
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
