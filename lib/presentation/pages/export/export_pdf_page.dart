// --- PDF Preview Screen ---
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviewPdfScreen extends ConsumerWidget {
  final dynamic pdf;
  const PreviewPdfScreen({super.key, required this.pdf});

  get exportService => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              await exportService.printDocument(pdf);
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await launchUrl(Uri.file(pdf.path));
            },
          ),
        ],
      ),
      body: PdfPreview(build: (format) => pdf.save()),
    );
  }
}
