// widgets/export_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/resume_template_provider.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/presentation/widgets/template_selector.dart';

import '../../core/providers/export_provider.dart';
import '../../core/utils/document_creator.dart';

class ExportButtons extends ConsumerWidget {
  final ResumeData resumeData;
  const ExportButtons({super.key, required this.resumeData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportService = ref.read(exportProvider);
    int idx;

    return Row(
      children: [
        // Botão PDF
        ElevatedButton.icon(
          icon: Icon(Icons.picture_as_pdf),
          label: Text('PDF'),
          onPressed: () {
            final template = ref.read(selectedTemplateProvider);
            final pdf = DocumentBuilder(template).generate(resumeData, context);
            context.goNamed('preview-pdf', extra: pdf);

            //await exportService.exportToPDF(pdf);
          },
        ),
        SizedBox(width: 5),
        // Botão Imprimir
        ElevatedButton.icon(
          icon: Icon(Icons.print),
          label: Text('Imprimir'),
          onPressed: () async {
            idx = ref.read(selectedTemplateIndexProvider);
            final template = ref.read(availableTemplatesProvider)[idx];
            //var pdf = DocumentBuilder.buildPDF(context, resumeData);
            final pdf = DocumentBuilder(template).generate(resumeData, context);
            await exportService.printDocument(pdf);
          },
        ),
        SizedBox(width: 5),
        TemplateSelector(),
        SizedBox(width: 5),
        /* ref.read(availableTemplatesProvider)[idx].id == 'international'
            ? LanguageSelector(resume: resumeData)
            : SizedBox.shrink(), */
      ],
    );
  }
}
