import 'package:flutter/material.dart';

import '../../../../data/models/cv_data.dart';

class EducationList extends StatelessWidget {
  final List<Education> items;
  final TextTheme theme;

  const EducationList({super.key, required this.items, required this.theme});

  @override
  Widget build(BuildContext c) {
    if (items.isEmpty) return const Text('Nenhuma formação');
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder:
          (c, i) => ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(
              "${items[i].school} - ${items[i].degree}",
              style: theme.bodyMedium?.copyWith(height: 1.5),
            ),
            subtitle: Text(
              "${items[i].startDate} - ${items[i].endDate ?? 'Atual'}",
              style: theme.bodySmall?.copyWith(height: 1.2),
            ),
          ),
    );
  }
}
