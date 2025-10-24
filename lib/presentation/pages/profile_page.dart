import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import '../widgets/layout_template.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final l10n = AppLocalizations.of(context)!;

    return LayoutTemplate(
      selectedIndex: 1,
      child: userProfile.when(
        data: (user) {
          if (user == null) {
            return Center(child: Text(l10n.profilePage_userNotFound));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context, user, l10n),
                const SizedBox(height: 24),
                _buildSubscriptionCard(context, user, l10n),
                const SizedBox(height: 24),
                _buildQuickActions(context, l10n),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Text(
                l10n.profilePage_errorLoadingProfile(error.toString()),
              ),
            ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    dynamic user,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Semantics(
          label:
              user.profilePictureUrl != null
                  ? l10n.profilePage_profilePictureSemanticLabel(
                    user.name ?? '',
                  )
                  : l10n.profilePage_avatarSemanticLabel(user.name ?? ''),
          child: CircleAvatar(
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
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name ?? l10n.profilePage_defaultUserName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email ?? l10n.profilePage_defaultEmail,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard(
    BuildContext context,
    dynamic user,
    AppLocalizations l10n,
  ) {
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
              l10n.profilePage_mySubscription,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                isPremium ? Icons.star : Icons.check_circle_outline,
                color: isPremium ? Colors.amber : Colors.green,
                semanticLabel:
                    isPremium
                        ? l10n.profilePage_premiumPlanStarIconSemanticLabel
                        : l10n.profilePage_freePlanCheckIconSemanticLabel,
              ),
              title: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPremium
                          ? l10n.profilePage_premiumPlan
                          : l10n.profilePage_freePlan,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isPremium
                          ? l10n.profilePage_premiumPlanDescription
                          : l10n.profilePage_freePlanDescription,
                    ),
                  ],
                ),
              ),
            ),
            if (!isPremium)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => context.goNamed('buy'),
                    child: Text(l10n.profilePage_upgrade),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profilePage_quickActions,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: Icon(
            Icons.edit,
            semanticLabel: l10n.profilePage_editIconSemanticLabel,
          ),
          title: Text(l10n.profilePage_editProfile),
          onTap: () => context.goNamed('edit-profile'),
        ),
        ListTile(
          leading: Icon(
            Icons.history,
            semanticLabel: l10n.profilePage_historyIconSemanticLabel,
          ),
          title: Text(l10n.profilePage_viewResumeHistory),
          onTap: () => context.goNamed('history'),
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            semanticLabel: l10n.profilePage_settingsIconSemanticLabel,
          ),
          title: Text(l10n.profilePage_settings),
          onTap: () => context.goNamed('settings'),
        ),
      ],
    );
  }
}
