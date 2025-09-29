import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/editor/editor_providers.dart';
import 'package:intelliresume/data/models/cv_data.dart';

class ExperienceList extends ConsumerWidget {
  // Changed to ConsumerWidget
  final List<Experience> items;
  final TextTheme? theme;
  const ExperienceList({super.key, required this.items, this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef
    if (items.isEmpty) return const Text('Nenhuma experiência');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (c, i) {
        final item = items[i];
        return Semantics(
          label:
              'Experiência ${i + 1}: ${item.company} em ${item.position}. Toque para editar.',
          child: ListTile(
            leading: const Icon(Icons.work_outline),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.company} - ${item.position}",
                  style: theme?.bodyMedium?.copyWith(height: 1.5),
                ),
                Text(
                  "${item.startDate} - ${item.endDate ?? 'Atual'}",
                  style: theme!.bodySmall?.copyWith(height: 1.2),
                ),
              ],
            ),
            subtitle: Text(
              item.description ?? '',
              style: theme!.bodySmall?.copyWith(height: 1.2),
            ),
            onTap: () {
              ref.read(editRequestProvider.notifier).state = EditRequest(
                section: SectionType.experience,
                index: i,
              );
            },
          ),
        );
      },
    );
  }
}
