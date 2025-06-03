// lib/widgets/side_menu.dart
import 'package:flutter/material.dart';
import 'package:intelliresume/data/datasources/remote/auth_resume_ds.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.instance.currentUser;

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
          UserAccountsDrawerHeader(
            accountName: Text(currentUser?.displayName ?? 'Usuário'),
            accountEmail: Text(currentUser?.email ?? 'email@exemplo.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                currentUser?.displayName?.substring(0, 1) ?? 'U',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: ListView(
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
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selectedIndex == index,
      selectedTileColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.1),
      onTap: () => onDestinationSelected(index),
    );
  }
}
