import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/editor/editor_providers.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/generated/app_localizations.dart';

class CertificateList extends ConsumerWidget {
  final List<Certificate> items;
  final TextTheme? theme;
  const CertificateList({super.key, required this.items, this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    if (items.isEmpty) return Text(l10n.preview_noCertificates);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (c, i) {
        final item = items[i];
        return Semantics(
          label: l10n.preview_certificateSemanticLabel(
            i + 1,
            item.courseName ?? '',
          ),
          child: ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.courseName ?? '',
                  style: theme?.bodyMedium?.copyWith(height: 1.5),
                ),
                Text(
                  item.institution ?? '',
                  style: theme!.bodySmall?.copyWith(height: 1.2),
                ),
              ],
            ),
            subtitle: Text(
              "${item.startDate} - ${item.endDate ?? l10n.preview_current}",
              style: theme!.bodySmall?.copyWith(height: 1.2),
            ),
            onTap: () {
              ref.read(editRequestProvider.notifier).state = EditRequest(
                section: SectionType.certificate,
                index: i,
              );
            },
          ),
        );
      },
    );
  }
}
