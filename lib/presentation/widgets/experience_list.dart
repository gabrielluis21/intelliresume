import 'package:flutter/material.dart';

class ExperienceList extends StatelessWidget {
  final List<String> items;
  const ExperienceList({super.key, required this.items});
  @override
  Widget build(BuildContext c) {
    if (items.isEmpty) return const Text('Nenhuma experiência');
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder:
          (c, i) => ListTile(
            leading: const Icon(Icons.work_outline),
            title: Text(items[i]),
          ),
    );
  }
}
