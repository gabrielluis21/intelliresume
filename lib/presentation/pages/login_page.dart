import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/cv_provider.dart';
import '../../core/providers/user_provider.dart';
import '../../data/datasources/remote/auth_resume_ds.dart';
import '../../routes/app_routes.dart';
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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _loading = true);
    try {
      final logged = await AuthService.instance.signIn(
        email: email,
        password: password,
      );

      final userProfileRepository = ref.read(userProfileRepositoryProvider);
      final user = await userProfileRepository.watchProfile(logged.uid).first;
      print(user.toJson());
      ref.read(resumeProvider.notifier).updatePersonalInfo(user);
      //ref.(resumeProvider);

      ref.watch(routerProvider).goNamed('home');
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
                      t.login,
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        child:
                            _loading
                                ? const CircularProgressIndicator.adaptive()
                                : Text(t.login),
                      ),
                    ),
                    TextButton(
                      onPressed:
                          () => ref.watch(routerProvider).goNamed('signup'),
                      child: Text(t.signup),
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
