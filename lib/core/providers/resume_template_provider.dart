import 'dart:io';

import 'package:docx_template/docx_template.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/templates/resume_template.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

final templateListProvider = Provider<List<Template>>(
  (ref) => [
    Template(id: 'clean', name: 'Clean', fontFamily: 'Roboto'),
    Template(id: 'modern', name: 'Modern', fontFamily: 'OpenSans'),
  ],
);

final selectedTemplateProvider = StateProvider<Template>(
  (ref) => ref.watch(templateListProvider)[0],
);

final pdfFileProvider = FutureProvider<File>((ref) async {
  final template = ref.watch(selectedTemplateProvider);
  return await generatePdf(template);
});

final docxFileProvider = FutureProvider<File>((ref) async {
  final template = ref.watch(selectedTemplateProvider);
  return await generateDocx(template);
});

// --- Generation Functions ---
Future<File> generatePdf(Template template) async {
  final pdf = pw.Document();
  // Exemplo de layout simples; customize por template
  pdf.addPage(
    pw.Page(
      build:
          (context) =>
              pw.Center(child: pw.Text('Currículo - Template: \$template')),
    ),
  );
  final dir = await getTemporaryDirectory();
  final file = File('\${dir.path}/resume_${template.name}.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}

Future<File> generateDocx(Template template) async {
  // Carrega o modelo DOCX embutido em assets
  final bytes = await rootBundle.load('assets/templates/${template.name}.docx');
  final docx = await DocxTemplate.fromBytes(bytes.buffer.asUint8List());

  // Exemplo de contexto para substituição
  final content =
      Content()
        ..add(TextContent('name', 'Seu Nome'))
        ..add(TextContent('email', 'seunome@email.com'));

  final d = await docx.generate(content);
  final dir = await getTemporaryDirectory();
  final file = File('\${dir.path}/resume_\${template}.docx');
  if (d != null) await file.writeAsBytes(d, flush: true);
  return file;
}
