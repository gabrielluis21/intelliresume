import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/editor/editor_providers.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/generated/app_localizations.dart';

class ExperienceList extends ConsumerWidget {
  // Changed to ConsumerWidget
  final List<Experience> items;
  final TextTheme? theme;
  const ExperienceList({super.key, required this.items, this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Added WidgetRef
    if (items.isEmpty) return Text(l10n.preview_noExperience);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (c, i) {
        final item = items[i];
        return Semantics(
          label: l10n.preview_experienceSemanticLabel(
            i + 1,
            item.company ?? '',
            item.position ?? '',
          ),
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
                  "${item.startDate} - ${item.endDate ?? l10n.preview_current}",
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
