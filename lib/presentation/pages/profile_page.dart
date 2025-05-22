import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../core/utils/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final user = AuthService.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text(t.profile)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 48,
                child: Text(user?.email?[0].toUpperCase() ?? '?'),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(user?.email ?? ''),
                subtitle: Text(t.email),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  await AuthService.instance.signOut();
                  AppRoutes.router.pushReplacementNamed('/login');
                },
                icon: const Icon(Icons.logout),
                label: Text(t.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
