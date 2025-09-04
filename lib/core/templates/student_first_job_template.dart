import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intelliresume/data/models/cv_data.dart';

// ignore: unused_import
import '../../core/utils/document_creator.dart';

/// Template para estudantes ou primeiro emprego, baseado na imagem fornecida.
///
/// Características:
/// - Layout de duas colunas.
/// - Seções claras para Educação, Cursos, Projetos e Habilidades.
/// - Design minimalista e profissional.
class StudentFirstJobTemplate {
  const StudentFirstJobTemplate();

  pw.Document generate(ResumeData resumeData, BuildContext context) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // --- CABEÇALHO ---
              _buildHeader(resumeData),
              pw.SizedBox(height: 20),

              // --- CONTEÚDO PRINCIPAL (DUAS COLUNAS) ---
              pw.Expanded(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // --- COLUNA DA ESQUERDA ---
                    pw.Expanded(flex: 5, child: _buildLeftColumn(resumeData)),
                    pw.SizedBox(width: 30),

                    // --- COLUNA DA DIREITA ---
                    pw.Expanded(flex: 5, child: _buildRightColumn(resumeData)),
                  ],
                ),
              ),

              // --- RODAPÉ / CONTATO ---
              _buildFooter(resumeData),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(ResumeData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          data.personalInfo?.name ?? 'Nome não informado',
          style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          // Usando o campo "objetivo" como subtítulo, conforme o design.
          data.objective ?? 'Estudante de Engenharia de Software',
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
      ],
    );
  }

  pw.Widget _buildLeftColumn(ResumeData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // --- SEÇÃO EDUCAÇÃO ---
        _buildSectionTitle('Educação'),
        ...(data.educations != null && data.educations!.isNotEmpty
            ? data.educations!.map(
              (edu) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "${edu.school}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    '${edu.startDate} - ${edu.endDate}',
                    style: const pw.TextStyle(color: PdfColors.grey600),
                  ),
                  pw.Text("${edu.degree}"),
                  pw.SizedBox(height: 10),
                ],
              ),
            )
            : [pw.Text("Sem experiências registradas")]),
        pw.SizedBox(height: 20),

        // --- SEÇÃO CURSOS (Exemplo estático) ---
        _buildSectionTitle('Cursos'),
        data.certificates == null || data.certificates!.isEmpty
            ? pw.Text("Sem certificados registrados")
            : pw.Column(
              children:
                  data.certificates!
                      .map(
                        (cert) =>
                            pw.Text('${cert.courseName} - ${cert.courseName}'),
                      )
                      .toList(),
            ),
        pw.SizedBox(height: 20),

        // --- SEÇÃO HABILIDADES ---
        _buildSectionTitle('Habilidades'),
        data.skills == null || data.skills!.isEmpty
            ? pw.Text("Sem habilidades registradas")
            : pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  data.skills!
                      .map((skill) => _buildSkillChip(skill.name!))
                      .toList(),
            ),
      ],
    );
  }

  pw.Widget _buildRightColumn(ResumeData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // --- SEÇÃO PROJETOS (usando Experiências) ---
        _buildSectionTitle('Projetos'),
        ...data.experiences!.map(
          (exp) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "${exp.company}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${exp.startDate} - ${exp.endDate}',
                style: const pw.TextStyle(color: PdfColors.grey600),
              ),
              pw.Text('${exp.description}'),
              pw.SizedBox(height: 10),
            ],
          ),
        ),
        pw.SizedBox(height: 20),

        // --- SEÇÃO SOBRE MIM ---
        _buildSectionTitle('Sobre Mim'),
        pw.Text(
          data.objective ??
              'Estudante de Engenharia de Software com sólida formação acadêmica e experiência prática em desenvolvimento de aplicações web e móveis.',
        ),
      ],
    );
  }

  pw.Widget _buildFooter(ResumeData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),
        pw.Text(data.personalInfo?.email ?? ''),
        pw.SizedBox(height: 4),
        pw.Text(data.personalInfo?.phone ?? ''),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildSkillChip(String skillName) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const pw.BoxDecoration(
        color: PdfColors.blue400,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(12)),
      ),
      child: pw.Text(
        skillName,
        style: const pw.TextStyle(color: PdfColors.white, fontSize: 10),
      ),
    );
  }
}
