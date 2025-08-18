import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/editor_providers.dart';

import '../../../../data/models/cv_data.dart';

class EducationList extends ConsumerWidget {
  // Changed to ConsumerWidget
  final List<Education> items;
  final TextTheme theme;

  const EducationList({super.key, required this.items, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef
    if (items.isEmpty) return const Text('Nenhuma formação');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder:
          (c, i) => InkWell(
            // Wrapped with InkWell
            onTap: () {
              // Set the edit request for the tapped item
              ref.read(editRequestProvider.notifier).state = EditRequest(
                section: SectionType.education,
                index: i,
              );
            },
            child: ListTile(
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
          ),
    );
  }
}
