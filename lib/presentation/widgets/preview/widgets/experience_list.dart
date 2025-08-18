import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/editor_providers.dart';
import 'package:intelliresume/data/models/cv_data.dart';

class ExperienceList extends ConsumerWidget { // Changed to ConsumerWidget
  final List<Experience> items;
  final TextTheme? theme;
  const ExperienceList({super.key, required this.items, this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef
    if (items.isEmpty) return const Text('Nenhuma experiência');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (c, i) => InkWell( // Wrapped with InkWell
        onTap: () {
          // Set the edit request for the tapped item
          ref.read(editRequestProvider.notifier).state = EditRequest(
            section: SectionType.experience,
            index: i,
          );
        },
        child: ListTile(
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
      ),
    );
  }
}
