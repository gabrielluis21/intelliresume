import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';

class SideMenu extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

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
                  accountName: const Text('Bem-vindo!'),
                  accountEmail: const Text('Faça login ou cadastre-se'),
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
                (err, stack) => const SizedBox(
                  height: 180,
                  child: Center(child: Text('Erro ao carregar perfil')),
                ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero, // Remove o padding do ListView
              children: [
                _buildListTile(
                  context,
                  icon: Icons.home,
                  label: 'Inicio',
                  index: 0,
                ),
                _buildListTile(
                  context,
                  icon: Icons.person,
                  label: 'Perfil',
                  index: 1,
                ),
                _buildListTile(
                  context,
                  icon: Icons.history,
                  label: 'Histórico',
                  index: 2,
                ),
                _buildListTile(
                  context,
                  icon: Icons.add,
                  label: 'Novo CV',
                  index: 3,
                ),
                const Divider(),
                _buildListTile(
                  context,
                  icon: Icons.settings,
                  label: 'Configurações',
                  index: 4,
                ),
                // Oculta o botão de sair se o usuário não estiver logado
                if (userProfileAsync.valueOrNull != null)
                  _buildListTile(
                    context,
                    icon: Icons.logout,
                    label: 'Sair',
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
    final bool isSelected = selectedIndex == index;
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
      onTap: () => onDestinationSelected(index),
    );
  }
}
