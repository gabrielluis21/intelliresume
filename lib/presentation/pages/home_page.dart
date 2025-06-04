// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/routes/app_routes.dart';

import '../widgets/layout_template.dart';
import '../widgets/cv_card.dart';
import '../../data/models/cv_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final dynamic _cvService = Object();
  CVModel? _latestCV;
  final List<dynamic> _history = [];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Implementação existente
  }

  void _createNewCV() {
    ref.watch(routerProvider).goNamed('form');
  }

  void _editCV(dynamic cv) {
    ref.watch(routerProvider).goNamed('form', extra: cv);
  }

  void _deleteCV(dynamic cv) async {
    await _cvService.delete(cv.id);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutTemplate(
      selectedIndex: 0,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    );
  }
}
