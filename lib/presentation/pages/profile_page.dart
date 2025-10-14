import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import '../widgets/layout_template.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return LayoutTemplate(
      selectedIndex: 1,
      child: userProfile.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Usuário não encontrado.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context, user),
                const SizedBox(height: 24),
                _buildSubscriptionCard(context, user),
                const SizedBox(height: 24),
                _buildQuickActions(context),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Erro ao carregar perfil: $error'),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              user.profilePictureUrl != null
                  ? NetworkImage(user.profilePictureUrl!)
                  : null,
          child:
              user.profilePictureUrl == null
                  ? Text(
                    user.name?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(fontSize: 32),
                  )
                  : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name ?? 'Usuário',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email ?? 'email@exemplo.com',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard(BuildContext context, dynamic user) {
    final plan = user.plan ?? PlanType.free;
    final isPremium = plan != PlanType.free;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Minha Assinatura',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                isPremium ? Icons.star : Icons.check_circle_outline,
                color: isPremium ? Colors.amber : Colors.green,
              ),
              title: Text(
                isPremium ? 'Plano Premium' : 'Plano Gratuito',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                isPremium
                    ? 'Você tem acesso a todos os recursos.'
                    : 'Acesse mais recursos fazendo o upgrade.',
              ),
            ),
            if (!isPremium)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => context.goNamed('buy'),
                    child: const Text('Fazer Upgrade'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ações Rápidas', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Editar Perfil'),
          onTap: () => context.goNamed('edit-profile'),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Ver Histórico de Currículos'),
          onTap: () => context.goNamed('history'),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Configurações'),
          onTap: () => context.goNamed('settings'),
        ),
      ],
    );
  }
}
