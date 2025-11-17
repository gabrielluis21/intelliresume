import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:intelliresume/generated/app_localizations.dart';

import 'side_menu.dart';

class LayoutTemplate extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutTemplate({super.key, required this.navigationShell});

  @override
  ConsumerState<LayoutTemplate> createState() => _LayoutTemplateState();
}

class _LayoutTemplateState extends ConsumerState<LayoutTemplate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AppLocalizations l10n;

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

    // Use goBranch to navigate to the selected branch
    widget.navigationShell.goBranch(
      index,
      // Aims to keep the navigation stack for the selected branch
      initialLocation: index == widget.navigationShell.currentIndex,
    );
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
              ? Drawer(child: SideMenu(navigationShell: widget.navigationShell))
              : null,
      body: Row(
        children: [
          if (!isMobile) SideMenu(navigationShell: widget.navigationShell),
          Expanded(child: widget.navigationShell),
        ],
      ),
    );
  }
}
