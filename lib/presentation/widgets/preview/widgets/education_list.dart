import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/editor/editor_providers.dart';
import 'package:intelliresume/generated/app_localizations.dart';

import '../../../../data/models/cv_data.dart';

class EducationList extends ConsumerWidget {
  // Changed to ConsumerWidget
  final List<Education> items;
  final TextTheme? theme;

  const EducationList({super.key, required this.items, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Added WidgetRef
    if (items.isEmpty) return Text(l10n.preview_noEducation);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (c, i) {
        final item = items[i];
        return Semantics(
          label: l10n.preview_educationSemanticLabel(
            i + 1,
            item.degree ?? '',
            item.school ?? '',
          ),
          child: ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.school} - ${item.degree}",
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
                section: SectionType.education,
                index: i,
              );
            },
          ),
        );
      },
    );
  }
}
