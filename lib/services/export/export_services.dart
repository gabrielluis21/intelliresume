import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:docx_template/docx_template.dart' as docx;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/cv_data.dart';
import '../../data/models/resume_template.dart';

class ExportService {
  Future<bool> exportToPdf({
    required BuildContext context,
    required ResumeTemplate template,
    required ResumeData resumeData,
  }) async {
    try {
      final pdfBytes = await _generatePdf(template, resumeData);
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: '${resumeData.personalInfo!.name}_CV.pdf',
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao gerar PDF: $e')));
      return false;
    }
  }

  Future<bool> exportToDocx({
    required BuildContext context,
    required ResumeTemplate template,
    required ResumeData resumeData,
  }) async {
    try {
      final docxFile = await _generateDocx(resumeData);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(docxFile.path)],
          subject: 'Currículo - ${resumeData.personalInfo!.name}',
          text: 'Confira meu currículo',
        ),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao gerar DOCX: $e')));
      return false;
    }
  }

  Future<Uint8List> _generatePdf(
    ResumeTemplate template,
    ResumeData resumeData,
  ) async {
    final pdf = pw.Document();
    final pdfTheme = await _mapThemeToPdf(template.theme, template.fontFamily);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildPdfHeader(pdfTheme, resumeData.personalInfo!),
              if (template.columns == 1)
                _buildPdfSingleColumnContent(pdfTheme, resumeData)
              else
                _buildPdfTwoColumnContent(pdfTheme, resumeData),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<File> _generateDocx(ResumeData resumeData) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(
      '${tempDir.path}/${resumeData.personalInfo!.name}_CV.docx',
    );
    await file.create(recursive: true);

    // Implementação básica de um DOCX com conteúdo estruturado
    final bytes = _buildBasicDocxBytes(resumeData);
    await file.writeAsBytes(bytes);

    return file;
  }

  Uint8List _buildBasicDocxBytes(ResumeData resumeData) {
    // Implementação simplificada para gerar um DOCX válido
    // (Na prática, use uma biblioteca de geração de DOCX ou templates)
    final content = '''
      <html>
        <body>
          <h1>${resumeData.personalInfo!.name}</h1>
          <p>Email: ${resumeData.personalInfo!.email}</p>
          <p>Telefone: ${resumeData.personalInfo!.phone}</p>
          <h2>Sobre</h2>
          <p>${resumeData.about}</p>
          <h2>Experiências</h2>
          <ul>
            ${resumeData.experiences!.map((e) => '<li>${e.position} - ${e.company}</li>').join()}
          </ul>
        </body>
      </html>
    ''';

    return Uint8List.fromList(content.codeUnits);
  }

  // ========== Métodos auxiliares PDF ==========
  Future<pw.ThemeData> _mapThemeToPdf(
    ThemeData theme,
    String fontFamily,
  ) async {
    return pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load('assets/fonts/$fontFamily.ttf')),
      bold: pw.Font.ttf(
        await rootBundle.load('assets/fonts/${fontFamily}_Bold.ttf'),
      ),
      italic: pw.Font.ttf(
        await rootBundle.load('assets/fonts/${fontFamily}_Italic.ttf'),
      ),
    );
  }

  pw.Widget _buildPdfHeader(pw.ThemeData theme, UserProfile info) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          info.name!,
          style: theme.defaultTextStyle.copyWith(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(info.email!, style: theme.defaultTextStyle),
        pw.Text(info.phone!, style: theme.defaultTextStyle),
        pw.Divider(thickness: 2),
      ],
    );
  }

  pw.Widget _buildPdfSingleColumnContent(pw.ThemeData theme, ResumeData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Sobre'),
        pw.Text(data.about!),
        _buildSectionTitle(theme, 'Objetivo'),
        pw.Text(data.objective!),
        _buildSectionTitle(theme, 'Experiência Profissional'),
        ...data.experiences!.map((e) => _buildExperience(theme, e)),
        _buildSectionTitle(theme, 'Educação'),
        ...data.educations!.map((e) => _buildEducation(theme, e)),
        _buildSectionTitle(theme, 'Habilidades'),
        _buildSkills(theme, data.skills!),
        _buildSectionTitle(theme, 'Projetos'),
        ...data.projects!.map((p) => _buildProject(theme, p)),
      ],
    );
  }

  pw.Widget _buildPdfTwoColumnContent(pw.ThemeData theme, ResumeData data) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 4,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(theme, 'Experiência'),
              ...data.experiences!.map((e) => _buildExperience(theme, e)),
              _buildSectionTitle(theme, 'Educação'),
              ...data.educations!.map((e) => _buildEducation(theme, e)),
            ],
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          flex: 6,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(theme, 'Habilidades'),
              _buildSkills(theme, data.skills!),
              _buildSectionTitle(theme, 'Projetos'),
              ...data.projects!.map((p) => _buildProject(theme, p)),
              _buildSectionTitle(theme, 'Sobre'),
              pw.Text(data.about!),
              _buildSectionTitle(theme, 'Objetivo'),
              pw.Text(data.objective!),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSectionTitle(pw.ThemeData theme, String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 12, bottom: 4),
      child: pw.Text(
        title,
        style: theme.defaultTextStyle.copyWith(
          fontWeight: pw.FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  pw.Widget _buildExperience(pw.ThemeData theme, Experience exp) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            exp.position ?? '',
            style: theme.defaultTextStyle.copyWith(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(exp.company ?? ''),
          pw.Text('${exp.startDate} - ${exp.endDate ?? 'Atual'}'),
          pw.Text(exp.description ?? ''),
        ],
      ),
    );
  }

  pw.Widget _buildEducation(pw.ThemeData theme, Education edu) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            edu.degree ?? "",
            style: theme.defaultTextStyle.copyWith(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(edu.school ?? ''),
          pw.Text('${edu.startDate} - ${edu.endDate ?? 'Cursand'}'),
        ],
      ),
    );
  }

  pw.Widget _buildSkills(pw.ThemeData theme, List<Skill> skills) {
    return pw.Wrap(
      spacing: 4,
      runSpacing: 4,
      children:
          skills
              .map(
                (skill) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    skill.name ?? '',
                    style: theme.defaultTextStyle.copyWith(fontSize: 12),
                  ),
                ),
              )
              .toList(),
    );
  }

  pw.Widget _buildProject(pw.ThemeData theme, Project project) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            project.name ?? 'Projeto sem nome',
            style: theme.defaultTextStyle.copyWith(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(project.description ?? ''),
        ],
      ),
    );
  }
}
