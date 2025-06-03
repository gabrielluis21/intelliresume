// lib/widgets/layout_template.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/datasources/remote/auth_resume_ds.dart';
import 'side_menu.dart'; // Criaremos este compon

class LayoutTemplate extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

  const LayoutTemplate({
    super.key,
    required this.child,
    this.selectedIndex = 0,
  });

  @override
  State<LayoutTemplate> createState() => _LayoutTemplateState();
}

class _LayoutTemplateState extends State<LayoutTemplate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onDestinationSelected(int index) {
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
        context.goNamed('form');
        break;
      case 4:
        context.goNamed('settings');
        break;
      case 5:
        AuthService.instance.signOut();
        context.goNamed('login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('IntelliResume'),
        leading:
            isMobile
                ? IconButton(
                  icon: const Icon(Icons.menu),
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
