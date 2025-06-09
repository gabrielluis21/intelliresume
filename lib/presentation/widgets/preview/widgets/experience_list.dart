import 'package:flutter/material.dart';
import 'package:intelliresume/data/models/cv_data.dart';

class ExperienceList extends StatelessWidget {
  final List<Experience> items;
  final TextTheme? theme;
  const ExperienceList({super.key, required this.items, this.theme});

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
            title: Text(
              "${items[i].company} - ${items[i].position}",
              style: theme?.bodyMedium?.copyWith(height: 1.5),
            ),
            subtitle: Text(
              "${items[i].startDate} - ${items[i].endDate ?? 'Atual'}",
              style: theme!.bodySmall?.copyWith(height: 1.2),
            ),
          ),
    );
  }
}
