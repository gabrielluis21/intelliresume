// utils/document_builder.dart

//import 'dart:io';

//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelliresume/core/utils/app_localizations.dart'
    show AppLocalizations;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
//import 'package:docx_template/docx_template.dart' as docx;
import '../../data/models/cv_data.dart';

class DocumentBuilder {
  static late dynamic _networkImage;

  static pw.Document buildPDF(BuildContext context, ResumeData resumeData) {
    final pdf = pw.Document();
    final t = AppLocalizations.of(context);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(resumeData),
              _buildSection('Objetivo', resumeData.objective!, t),
              _buildExperienceSection(resumeData.experiences!, t),
              _buildEducationSection(resumeData.educations!, t),
              _buildSkillsSection(resumeData.skills!, t),
              _buildSocialsSection(resumeData.socials!, t),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static _downloadImage(String url) async {
    try {
      if (url.isNotEmpty) {
        final response = await NetworkAssetBundle(Uri.parse(url)).load(url);
        if (response.lengthInBytes > 0) {
          _networkImage = response.buffer.asUint8List();
        }
      }
    } catch (e) {
      print('Error loading image: $e');
    }
    return null;
  }

  static pw.Widget _buildHeader(ResumeData data) {
    _downloadImage(data.personalInfo!.profilePictureUrl ?? '');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        data.personalInfo!.profilePictureUrl != null
            ? pw.Image(_networkImage, width: 100, height: 100)
            : pw.SizedBox.shrink(),
        pw.Text(
          data.personalInfo!.name!,
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('${data.personalInfo!.email} | ${data.personalInfo!.phone}'),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildSection(
    String title,
    String content,
    AppLocalizations t,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text(content.isNotEmpty ? content : t.noObjectives),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildExperienceSection(
    List<Experience> experiences,
    AppLocalizations t,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Experiências',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        experiences.isEmpty
            ? pw.Text(t.noExperiences)
            : _buidExpList(experiences),

        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buidExpList(List<Experience> experiences) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (var exp in experiences)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('- ${exp.company} - ${exp.position}'),
              pw.Text('   ${exp.startDate} - ${exp.endDate}'),
              pw.SizedBox(height: 8),
            ],
          ),
      ],
    );
  }

  static pw.Widget _buildEducationSection(
    List<Education> educations,
    AppLocalizations t,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Educação',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        educations.isEmpty
            ? pw.Text(t.noEducations)
            : _buildEduList(educations),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildEduList(List<Education> educations) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (var edu in educations)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('- ${edu.school} - ${edu.degree}'),
              pw.Text('   ${edu.startDate} - ${edu.endDate}'),
              pw.SizedBox(height: 8),
            ],
          ),
      ],
    );
  }

  static pw.Widget _buildSkillsSection(List<Skill> skills, AppLocalizations t) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Experiências',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        skills.isEmpty ? pw.Text(t.noSkills) : _buildSkillList(skills),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildSkillList(List<Skill> skills) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children:
          skills
              .map(
                (skill) => pw.Text(
                  '- ${skill.name} (${skill.level})',
                  style: pw.TextStyle(fontSize: 12),
                ),
              )
              .toList(),
    );
  }

  static pw.Widget _buildSocialsSection(
    List<Social> socials,
    AppLocalizations t,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Experiências',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        socials.isEmpty ? pw.Text(t.noSocialLinks) : _buildSocialList(socials),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildSocialList(List<Social> socials) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children:
          socials
              .map(
                (social) => pw.Text(
                  '- ${social.platform} (${social.url})',
                  style: pw.TextStyle(fontSize: 12),
                ),
              )
              .toList(),
    );
  }

  // --- SEÇÃO DOCX (CORRIGIDA E MELHORADA) ---

  /* static Future<Uint8List?> buildDOCX(
    BuildContext context,
    ResumeData resumeData,
  ) async {
    try {
      final t = AppLocalizations.of(context);

      // 1. Carregar template
      final ByteData templateData = await rootBundle.load('docx/template.docx');
      final Uint8List templateBytes = templateData.buffer.asUint8List();
      final docxTpl = await docx.DocxTemplate.fromBytes(templateBytes);

      // 2. Criar objeto de conteúdo principal
      final content = docx.Content();
      // 3. Adicionar seções diretamente ao content
      // Informações pessoais
      content.add(
        docx.TextContent('name', resumeData.personalInfo?.name ?? ''),
      );
      content.add(
        docx.TextContent(
          'contact',
          '${resumeData.personalInfo?.email ?? ''} | ${resumeData.personalInfo?.phone ?? ''}',
        ),
      );

      content.add(docx.TextContent('about_me', resumeData.about ?? ''));

      // Objetivo
      content.add(
        docx.TextContent('objective', resumeData.objective ?? t.noObjectives),
      );

      // 4. Função para adicionar seções com tratamento de vazio
      void addSection({
        required String tag,
        required List<docx.Content> items,
        required String emptyText,
      }) {
        if (items.isNotEmpty) {
          content.add(docx.ListContent(tag, items));
        } else {
          content.add(docx.TextContent(tag, emptyText));
        }
      }

      // 5. Construir e adicionar cada seção
      // Experiências
      addSection(
        tag: 'experiences',
        items:
            (resumeData.experiences ?? [])
                .map(
                  (exp) =>
                      docx.Content()
                        ..add(
                          docx.TextContent('exp_company', exp.company ?? ''),
                        )
                        ..add(docx.TextContent('exp_title', exp.position ?? ''))
                        ..add(
                          docx.TextContent(
                            'exp_period',
                            '${exp.startDate ?? ''} - ${exp.endDate ?? ''}',
                          ),
                        ),
                )
                .toList(),
        emptyText: t.noExperiences,
      );

      // Educação
      addSection(
        tag: 'educations',
        items:
            (resumeData.educations ?? [])
                .map(
                  (edu) =>
                      docx.Content()
                        ..add(docx.TextContent('edu_school', edu.school ?? ''))
                        ..add(docx.TextContent('edu_title', edu.degree ?? ''))
                        ..add(
                          docx.TextContent(
                            'edu_period',
                            '${edu.startDate ?? ''} - ${edu.endDate ?? ''}',
                          ),
                        ),
                )
                .toList(),
        emptyText: t.noEducations,
      );

      // Habilidades
      addSection(
        tag: 'skills',
        items:
            (resumeData.skills ?? [])
                .map(
                  (skill) =>
                      docx.Content()
                        ..add(docx.TextContent('skill_name', skill.name ?? ''))
                        ..add(
                          docx.TextContent('skill_level', skill.level ?? ''),
                        ),
                )
                .toList(),
        emptyText: t.noSkills,
      );

      // Redes Sociais
      addSection(
        tag: 'socials',
        items:
            (resumeData.socials ?? [])
                .map(
                  (social) =>
                      docx.Content()
                        ..add(
                          docx.TextContent(
                            'social_platform',
                            social.platform ?? '',
                          ),
                        )
                        ..add(docx.TextContent('social_url', social.url ?? '')),
                )
                .toList(),
        emptyText: t.noSocialLinks,
      );

      // Projetos
      addSection(
        tag: 'projects',
        items:
            (resumeData.projects ?? [])
                .map(
                  (project) =>
                      docx.Content()
                        ..add(
                          docx.TextContent('project_name', project.name ?? ''),
                        )
                        ..add(
                          docx.TextContent(
                            'project_description',
                            project.description ?? '',
                          ),
                        )
                        ..add(
                          docx.TextContent('project_url', project.url ?? ''),
                        ),
                )
                .toList(),
        emptyText: t.noProjects,
      );

      content.sub.forEach((elementS, content) {
        print("Seção: $elementS");
        if (content is docx.TextContent) {
          print("$elementS: ${content.text}");
        } else if (content is docx.ListContent) {
          print("$elementS: ${content.list.length} items");
        } else {
          print("nenhum item encontrado");
        }
      });

      // 6. Gerar documento
      final generatedBytes = await docxTpl.generate(
        content,
        tagPolicy: docx.TagPolicy.saveText,
      );
      print(generatedBytes);
      //return Uint8List.fromList(generatedBytes ?? []);
      return Uint8List.fromList([]);
    } catch (e, s) {
      print('Erro ao gerar DOCX: $e');
      print('Stack Trace: $s');
      return null;
    }
  } */
}
