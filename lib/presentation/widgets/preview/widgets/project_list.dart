import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/editor/editor_providers.dart';
import 'package:intelliresume/data/models/cv_data.dart';

class ProjectList extends ConsumerWidget {
  final List<Project> items;
  final TextTheme? theme;
  const ProjectList({super.key, required this.items, this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const Text('Nenhum projeto');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (c, i) {
        final item = items[i];
        return Semantics(
          label:
              'Projeto ${i + 1}: ${item.name}. Toque para editar.',
          child: ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  style: theme?.bodyMedium?.copyWith(height: 1.5),
                ),
                Text(
                  "${item.startYear} - ${item.endYear ?? 'Atual'}",
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
                section: SectionType.project,
                index: i,
              );
            },
          ),
        );
      },
    );
  }
}
