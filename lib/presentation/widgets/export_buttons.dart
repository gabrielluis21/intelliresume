// widgets/export_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/export/export_provider.dart';
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

    return Row(
      children: [
        // Botão PDF
        ElevatedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('PDF'),
          onPressed: selectedTemplate == null
              ? null
              : () async {
                  final pdf = await selectedTemplate.buildPdf(resumeData, context);
                  context.goNamed('preview-pdf', extra: pdf);
                },
        ),
        const SizedBox(width: 5),
        // Botão Imprimir
        ElevatedButton.icon(
          icon: const Icon(Icons.print),
          label: const Text('Imprimir'),
          onPressed: selectedTemplate == null
              ? null
              : () async {
                  final pdf = await selectedTemplate.buildPdf(resumeData, context);
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