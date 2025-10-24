// widgets/export_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/export/export_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/presentation/pages/export/export_page.dart';
import 'package:intelliresume/presentation/widgets/template_selector.dart';

class ExportButtons extends ConsumerWidget {
  final ResumeData resumeData;
  const ExportButtons({super.key, required this.resumeData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportService = ref.read(exportProvider);
    final selectedTemplate = ref.watch(selectedTemplateProvider);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // Botão PDF
        ElevatedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: Text(l10n.pdfType),
          onPressed:
              selectedTemplate != null
                  ? () async {
                    final pdf = await selectedTemplate.buildPdf(
                      resumeData,
                      context,
                    );
                    context.goNamed('preview-pdf', extra: pdf);
                  }
                  : null,
        ),
        const SizedBox(width: 5),
        // Botão Imprimir
        ElevatedButton.icon(
          icon: const Icon(Icons.print),
          label: Text(l10n.exportButtons_print),
          onPressed:
              selectedTemplate == null
                  ? null
                  : () async {
                    final pdf = await selectedTemplate.buildPdf(
                      resumeData,
                      context,
                    );
                    await exportService.printDocument(pdf);
                  },
        ),
        const SizedBox(width: 5),
        const TemplateSelector(),
        const SizedBox(width: 5),
      ],
    );
  }
}
