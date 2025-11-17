import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';

class SideMenu extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const SideMenu({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          userProfileAsync.when(
            data: (user) {
              if (user == null) {
                // Cabeçalho para usuário deslogado ou estado inicial
                return UserAccountsDrawerHeader(
                  accountName: Text(AppLocalizations.of(context)!.welcome),
                  accountEmail: Text(
                    AppLocalizations.of(
                      context,
                    )!.sideBarMenu_loginOrCreateAccount,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
              // Cabeçalho para usuário logado
              return UserAccountsDrawerHeader(
                accountName: Text('${user.name}'),
                accountEmail: Text("${user.email}"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  backgroundImage:
                      user.profilePictureUrl != null &&
                              user.profilePictureUrl!.isNotEmpty
                          ? NetworkImage(user.profilePictureUrl!)
                          : null,
                  child:
                      user.profilePictureUrl == null ||
                              user.profilePictureUrl!.isEmpty
                          ? Text(
                            user.name != null && user.name!.isNotEmpty
                                ? user.name!.substring(0, 1).toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          )
                          : null,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
            loading:
                () => const SizedBox(
                  height: 180, // Altura similar ao UserAccountsDrawerHeader
                  child: Center(child: CircularProgressIndicator()),
                ),
            error:
                (err, stack) => SizedBox(
                  height: 180,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.sideBarMenu_errorLoadingProfile,
                    ),
                  ),
                ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero, // Remove o padding do ListView
              children: [
                _buildListTile(
                  context,
                  icon: Icons.home,
                  label: AppLocalizations.of(context)!.sideBarMenu_home,
                  index: 0,
                ),
                _buildListTile(
                  context,
                  icon: Icons.person,
                  label: AppLocalizations.of(context)!.sideBarMenu_profile,
                  index: 1,
                ),
                _buildListTile(
                  context,
                  icon: Icons.history,
                  label: AppLocalizations.of(context)!.sideBarMenu_history,
                  index: 2,
                ),
                _buildListTile(
                  context,
                  icon: Icons.add,
                  label: AppLocalizations.of(context)!.sideBarMenu_newCV,
                  index: 3,
                ),
                const Divider(),
                _buildListTile(
                  context,
                  icon: Icons.settings,
                  label: AppLocalizations.of(context)!.sideBarMenu_settings,
                  index: 4,
                ),
                // Oculta o botão de sair se o usuário não estiver logado
                if (userProfileAsync.value != null)
                  _buildListTile(
                    context,
                    icon: Icons.logout,
                    label: AppLocalizations.of(context)!.sideBarMenu_logout,
                    index: 5,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = navigationShell.currentIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      onTap: () {
        if (index == 3) {
          // New CV
          context.goNamed('editor-new');
        } else if (index == 5) {
          // Logout
          // Handle logout
        } else {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        }
      },
    );
  }
}
