// lib/pages/history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/utils/app_localizations.dart';
import '../../core/routes/app_routes.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});
  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('history') ?? [];
    setState(() {
      _history = raw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  Future<void> _delete(int idx) async {
    _history.removeAt(idx);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'history',
      _history.map((e) => jsonEncode(e)).toList(),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.history)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            _history.isEmpty
                ? Center(
                  child: Text(
                    t.noHistory,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
                : ListView.separated(
                  itemCount: _history.length,
                  separatorBuilder: (_, i) => const Divider(),
                  itemBuilder: (ctx, i) {
                    final item = _history[i];
                    final date = DateTime.parse(item['savedAt'] as String);
                    return ListTile(
                      title: Text(item['title'] ?? t.appTitle),
                      subtitle: Text('${date.toLocal()}'.split('.')[0]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _delete(i),
                      ),
                      onTap: () {
                        ref
                            .watch(routerProvider)
                            .goNamed(
                              'form',
                              // passe item como argumento para pré-carregar o formulário
                              extra: item['data'],
                            );
                      },
                    );
                  },
                ),
      ),
    );
  }
}
