// providers/export_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';

final exportProvider = Provider<ExportService>((ref) => ExportService());

class ExportService {
  // 1. Exportar para PDF
  Future<void> exportToPDF(pw.Document pdf) async {
    final bytes = await pdf.save();
    final isSaved = await FileSaver.instance.saveFile(
      name: 'Curriculo_IntelliResume',
      bytes: bytes,
      mimeType: MimeType.pdf,
    );

    print(
      isSaved.isNotEmpty
          ? 'PDF exportado com sucesso!'
          : 'Erro ao exportar PDF.',
    );
  }

  // 2. Exportar para DOCX
  Future<void> exportToDOCX(Uint8List docx) async {
    final isSaved = await FileSaver.instance.saveFile(
      name: 'Curriculo_IntelliResume',
      bytes: docx,
      mimeType: MimeType.microsoftWord,
    );

    print(
      isSaved.isNotEmpty
          ? 'DOCX exportado com sucesso!'
          : 'Erro ao exportar DOCX.',
    );
  }

  // 3. Imprimir
  Future<void> printDocument(pw.Document pdf) async {
    final bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (_) => bytes, format: PdfPageFormat.a4);
  }
}
