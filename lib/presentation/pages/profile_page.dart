// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/user_provider.dart';

import '../widgets/layout_template.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);

    return LayoutTemplate(
      selectedIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user.value?.profilePictureUrl?.substring(0, 1) ?? 'U',
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.value?.name ?? 'Usuário',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.value?.email ?? 'email@exemplo.com',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.goNamed('edit-profile'),
              icon: const Icon(Icons.edit),
              label: const Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
