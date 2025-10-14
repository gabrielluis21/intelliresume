import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/presentation/pages/history_page.dart';
import 'package:intelliresume/presentation/widgets/recent_resume_card.dart';
import '../widgets/layout_template.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumesAsync = ref.watch(resumesStreamProvider); // Usando o provider correto
    final userAsync = ref.watch(userProfileProvider);
    final theme = Theme.of(context);

    return LayoutTemplate(
      selectedIndex: 0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userAsync.when(
              data: (user) => Text(
                'Olá, ${user?.name ?? 'Usuário'}!',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              loading: () => const SizedBox(),
              error: (e, s) => const Text('Olá!'),
            ),
            const SizedBox(height: 8),
            Text(
              'Bem-vindo de volta. Pronto para conquistar sua próxima vaga?',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 32),
            _buildRecentResumesSection(context, resumesAsync),
            const SizedBox(height: 32),
            _buildQuickActionsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentResumesSection(
      BuildContext context, AsyncValue<List<dynamic>> resumesAsync) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seus Currículos', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: resumesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => const Center(child: Text('Não foi possível carregar os currículos.')),
            data: (resumes) {
              if (resumes.isEmpty) {
                return AddNewResumeCard(onTap: () => context.go('/editor/new'));
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: resumes.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index == resumes.length) {
                    return AddNewResumeCard(onTap: () => context.go('/editor/new'));
                  }
                  final cv = resumes[index];
                  return RecentResumeCard(
                    resume: cv,
                    onTap: () => context.go('/editor/${cv.id}'), // Navegação correta
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ações Rápidas', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5, // Ajuste para o tamanho do card
          children: [
            _buildActionCard(
              context,
              icon: Icons.history,
              label: 'Ver Histórico Completo',
              onTap: () => context.go('/history'),
            ),
            _buildActionCard(
              context,
              icon: Icons.palette_outlined,
              label: 'Explorar Modelos',
              onTap: () { /* Navegar para a galeria de modelos */ },
            ),
            _buildActionCard(
              context,
              icon: Icons.workspace_premium_outlined,
              label: 'Minha Assinatura',
              onTap: () => context.go('/buy'),
            ),
            _buildActionCard(
              context,
              icon: Icons.settings_outlined,
              label: 'Ajustes',
              onTap: () => context.go('/settings'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, size: 28, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: theme.textTheme.titleSmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
