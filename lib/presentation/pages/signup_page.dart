import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/app_localizations.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '', confirm = '';
  bool _loading = false;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).fieldRequired)),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.instance.signUp(email: email, password: password);
      AppRoutes.router.pushReplacement('/form');
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
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
                                  : t.fieldRequired,
                      onSaved: (v) => email = v!.trim(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: t.password,
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator:
                          (v) =>
                              (v != null && v.length >= 6)
                                  ? null
                                  : t.fieldRequired,
                      onSaved: (v) => password = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: t.password,
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator:
                          (v) =>
                              (v != null && v == password)
                                  ? null
                                  : t.fieldRequired,
                      onSaved: (v) => confirm = v!,
                    ),
                    const SizedBox(height: 24),
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
