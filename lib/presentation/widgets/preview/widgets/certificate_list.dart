import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/editor/editor_providers.dart';
import 'package:intelliresume/data/models/cv_data.dart';

class CertificateList extends ConsumerWidget {
  final List<Certificate> items;
  final TextTheme? theme;
  const CertificateList({super.key, required this.items, this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const Text('Nenhum certificado');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (c, i) {
        final item = items[i];
        return Semantics(
          label:
              'Certificado ${i + 1}: ${item.courseName}. Toque para editar.',
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
              "${item.startDate} - ${item.endDate ?? 'Atual'}",
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
