import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/data/data_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';

import 'side_menu.dart';

class LayoutTemplate extends ConsumerStatefulWidget {
  final Widget child;
  final int selectedIndex;

  const LayoutTemplate({
    super.key,
    required this.child,
    this.selectedIndex = 0,
  });

  @override
  ConsumerState<LayoutTemplate> createState() => _LayoutTemplateState();
}

class _LayoutTemplateState extends ConsumerState<LayoutTemplate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  late AppLocalizations l10n;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
  }

  void _onDestinationSelected(int index) {
    // Se o menu lateral estiver aberto (em modo mobile), fecha ele primeiro.
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }

    // Evita reconstrução desnecessária se o mesmo item for selecionado
    if (_selectedIndex == index && index != 5) {
      return; // index 5 é o logout, sempre executa
    }

    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        context.goNamed('home');
        break;
      case 1:
        context.goNamed('profile');
        break;
      case 2:
        context.goNamed('history');
        break;
      case 3:
        context.goNamed('editor-new');
        break;
      case 4:
        context.goNamed('settings');
        break;
      case 5: // Logout
        ref.read(signOutUseCaseProvider).call();
        // A navegação será tratada pelo GoRouter ao detectar a mudança de estado de autenticação
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(l10n.layoutTemplate_appTitle),
        leading:
            isMobile
                ? IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: l10n.layoutTemplate_openNavigationMenu,
                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                )
                : null,
      ),
      drawer:
          isMobile
              ? Drawer(
                child: SideMenu(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                ),
              )
              : null,
      body: Row(
        children: [
          if (!isMobile)
            SideMenu(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
            ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
