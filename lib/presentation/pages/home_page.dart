// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/cv_card.dart';
import '../../data/models/cv_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dynamic _cvService = Object();
  CVModel? _latestCV;
  List<dynamic> _history = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    //final allCVs = await _cvService.fetchAll();
    /* setState(() {
      _history = allCVs;
      if (allCVs.isNotEmpty) {
        _latestCV = allCVs.first;
      }
    }); */
  }

  void _createNewCV() {
    context.goNamed('form');
  }

  void _editCV(dynamic cv) {
    Navigator.pushNamed(context, 'form', arguments: cv);
  }

  void _deleteCV(dynamic cv) async {
    await _cvService.delete(cv.id);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('IntelliResume'),
        leading:
            isMobile
                ? Builder(
                  builder:
                      (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        tooltip: 'Abrir menu',
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                )
                : null,
      ),
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          if (!isMobile) _buildSideMenu(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_latestCV != null) ...[
                    Semantics(
                      label: 'Currículo mais recente',
                      child: CVCard(
                        cv: _latestCV!,
                        onEdit: () => _editCV(_latestCV!),
                        onDelete: () => _deleteCV(_latestCV!),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Semantics(
                    label: 'Histórico de currículos',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Histórico',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._history.map(
                          (cv) => CVCard(
                            cv: cv,
                            onEdit: () => _editCV(cv),
                            onDelete: () => _deleteCV(cv),
                            isCompact: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          isMobile
              ? FloatingActionButton(
                onPressed: _createNewCV,
                tooltip: 'Criar novo currículo',
                child: const Icon(Icons.add),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSideMenu() {
    return Semantics(
      container: true,
      label: 'Menu lateral',
      child: NavigationRail(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.goNamed('home');
              setState(() {
                _selectedIndex = index;
              });
              break;
            case 1:
              context.goNamed('profile');
              //Navigator.pushNamed(context, 'profile');
              setState(() {
                _selectedIndex = index;
              });
              break;
            case 2:
              context.goNamed('history');
              setState(() {
                _selectedIndex = index;
              });
              break;
            case 3:
              _createNewCV();
              break;
            case 4:
              context.go('Settings');
              break;
          }
        },
        labelType: NavigationRailLabelType.all,
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.home),
            label: Text('Inicio'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.person),
            label: Text('Perfil'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.history),
            label: Text('Histórico'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.add),
            label: Text('Novo CV'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.settings),
            label: Text('Configurações'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.logout),
            label: Text('Sair'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Text(
              'IntelliResume',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Colors.white),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico'),
            onTap: () => Navigator.pushNamed(context, '/history'),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Novo CV'),
            onTap: _createNewCV,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () => Navigator.pushNamed(context, '/logout'),
          ),
        ],
      ),
    );
  }
}
