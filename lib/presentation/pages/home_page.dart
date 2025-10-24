import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/presentation/pages/history_page.dart';
import 'package:intelliresume/presentation/widgets/recent_resume_card.dart';
import '../widgets/layout_template.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final resumesAsync = ref.watch(
      resumesStreamProvider,
    ); // Usando o provider correto
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
              data:
                  (user) => Text(
                    l10n.home_greeting(user?.name ?? l10n.userNotFound),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              loading: () => const SizedBox(),
              error: (e, s) => Text(l10n.home_greetingFallback),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.home_welcomeBackPrompt,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 32),
            _buildRecentResumesSection(context, resumesAsync, l10n),
            const SizedBox(height: 32),
            _buildQuickActionsSection(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentResumesSection(
    BuildContext context,
    AsyncValue<List<dynamic>> resumesAsync,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.home_yourResumes, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: resumesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stack) =>
                    Center(child: Text(l10n.home_couldNotLoadResumes)),
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
                    return AddNewResumeCard(
                      onTap: () => context.go('/editor/new'),
                    );
                  }
                  final cv = resumes[index];
                  return RecentResumeCard(
                    resume: cv,
                    onTap:
                        () =>
                            context.go('/editor/${cv.id}'), // Navegação correta
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.home_quickActions, style: theme.textTheme.titleLarge),
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
              label: l10n.home_viewFullHistory,
              onTap: () => context.go('/history'),
              iconSemanticLabel: l10n.home_historyIconSemanticLabel,
            ),
            _buildActionCard(
              context,
              icon: Icons.palette_outlined,
              label: l10n.home_exploreTemplates,
              onTap: () {
                /* Navegar para a galeria de modelos */
              },
              iconSemanticLabel: l10n.home_paletteIconSemanticLabel,
            ),
            _buildActionCard(
              context,
              icon: Icons.workspace_premium_outlined,
              label: l10n.home_mySubscription,
              onTap: () => context.go('/buy'),
              iconSemanticLabel: l10n.home_premiumIconSemanticLabel,
            ),
            _buildActionCard(
              context,
              icon: Icons.settings_outlined,
              label: l10n.home_settings,
              onTap: () => context.go('/settings'),
              iconSemanticLabel: l10n.home_settingsIconSemanticLabel,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required String iconSemanticLabel,
  }) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: theme.colorScheme.primary,
                semanticLabel: iconSemanticLabel,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: theme.textTheme.titleSmall)),
            ],
          ),
        ),
      ),
    );
  }
}
