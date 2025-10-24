// --- PDF Preview Screen ---
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/export/export_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviewPdfScreen extends ConsumerWidget {
  final dynamic pdf;
  const PreviewPdfScreen({super.key, required this.pdf});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportService = ref.read(exportProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exportPdfPage_previewPdf),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              await exportService.printDocument(pdf);
            },
            tooltip: l10n.exportPdfPage_print,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await launchUrl(Uri.file(pdf.path));
            },
            tooltip: l10n.exportPdfPage_download,
          ),
        ],
      ),
      body: PdfPreview(build: (format) => pdf.save()),
    );
  }
}
