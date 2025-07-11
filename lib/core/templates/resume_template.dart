// TEMPLATE INTERFACE
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intelliresume/core/utils/app_localizations.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class ResumeTemplate {
  String get id;
  String get displayName;
  PlanType get minPlan;

  pw.Document buildPdf(ResumeData data, BuildContext context);

  static final List<ResumeTemplate> allTemplates = [
    IntelliResumePatternTemplate(),
    ClassicMinimalTemplate(),
    StudantTemplate(),
    ModernSidebarTemplate(),
    TimelineTemplate(),
    InfographicTemplate(),
    InternationalTemplate(),
    TechDeveloper(),
  ];

  /// Retorna os templates permitidos para o plano
  static List<ResumeTemplate> templatesByPlan(PlanType plan) {
    return allTemplates.where((t) {
      return plan == PlanType.premium || t.minPlan == PlanType.free;
    }).toList();
  }
}

//PADRÃO INTELLIRESUME
class IntelliResumePatternTemplate implements ResumeTemplate {
  late dynamic _profileImage;

  IntelliResumePatternTemplate();

  @override
  pw.Document buildPdf(ResumeData data, BuildContext context) {
    final pdf = pw.Document();
    final translated = AppLocalizations.of(context);
    final headerPdf = _buildHeader(data);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              headerPdf,
              _buildSection('Objetivo', data.objective!, translated),
              _buildExperienceSection(data.experiences!, translated),
              _buildEducationSection(data.educations!, translated),
              _buildSkillsSection(data.skills!, translated),
              _buildSocialsSection(data.socials!, translated),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  @override
  String get displayName => 'Padrão IntelliResume';

  Future<void> _buildProfileImage(String? picUrl) async {
    if (picUrl != null && picUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(picUrl);
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          _profileImage = response.bodyBytes;
        }
      } catch (e) {
        print("falha no Download");
        print(e);
        _profileImage = null;
      }
    } else {
      _profileImage = null;
    }
  }

  pw.Widget _buildHeader(ResumeData data) {
    _buildProfileImage(data.personalInfo?.profilePictureUrl);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        data.personalInfo!.profilePictureUrl != null
            ? pw.Image(pw.MemoryImage(_profileImage!), width: 100, height: 100)
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

  pw.Widget _buildSection(String title, String content, AppLocalizations t) {
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

  pw.Widget _buildExperienceSection(
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

  pw.Widget _buidExpList(List<Experience> experiences) {
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

  pw.Widget _buildEducationSection(
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

  pw.Widget _buildEduList(List<Education> educations) {
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

  pw.Widget _buildSkillsSection(List<Skill> skills, AppLocalizations t) {
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

  pw.Widget _buildSkillList(List<Skill> skills) {
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

  pw.Widget _buildSocialsSection(List<Social> socials, AppLocalizations t) {
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

  pw.Widget _buildSocialList(List<Social> socials) {
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

  @override
  String get id => 'intelli_resume';

  @override
  PlanType get minPlan => PlanType.free;
}

// TEMPLATES IMPLEMENTADOS
class ClassicMinimalTemplate implements ResumeTemplate {
  @override
  String get displayName => 'Clássico Minimalista';

  @override
  pw.Document buildPdf(ResumeData data, BuildContext context) {
    //final translated = AppLocalizations.of(context);
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                data.personalInfo?.name ?? '',
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'Objetivo',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(data.objective ?? '—'),
              pw.SizedBox(height: 24),
              pw.Text(
                'Experiências',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              ...(data.experiences != null && data.experiences!.isNotEmpty
                  ? data.experiences!
                      .map(
                        (e) => pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                '${e.position}',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                '${e.company} | ${e.startDate} - ${e.endDate}',
                              ),
                              pw.Text(e.description ?? ''),
                            ],
                          ),
                        ),
                      )
                      .toList()
                  : [pw.Text("Sem experiência registrada")]),
              pw.SizedBox(height: 12),
              pw.Text(
                'Graduação',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              ...(data.educations != null && data.educations!.isNotEmpty
                  ? data.educations!
                      .map(
                        (e) => pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                '${e.degree}',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                '${e.school} | ${e.startDate} - ${e.endDate}',
                              ),
                              pw.Text(e.description ?? ''),
                            ],
                          ),
                        ),
                      )
                      .toList()
                  : [pw.Text("Sem graduações registradas")]),
              pw.SizedBox(height: 12),
              pw.Text(
                'Habilidades',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              ...(data.skills != null && data.skills!.isNotEmpty
                  ? data.skills!.map((s) => pw.Text('• ${s.name}')).toList()
                  : [pw.Text('Sem habilibdades registradas')]),
              pw.SizedBox(height: 12),
              // ... Outras seções (Educação, Skills, Links)
            ],
          );
        },
      ),
    );
    return doc;
  }

  @override
  String get id => 'classic_minimal';

  @override
  PlanType get minPlan => PlanType.free;
}

class ModernSidebarTemplate implements ResumeTemplate {
  @override
  String get displayName => 'Moderno com Sidebar';

  @override
  pw.Document buildPdf(ResumeData data, BuildContext context) {
    //final translated = AppLocalizations.of(context);
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Row(
            children: [
              // Sidebar
              pw.Container(
                width: 150,
                color: PdfColors.grey200,
                padding: pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      data.personalInfo?.name ?? '',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      'Habilidades',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    ...(data.skills != null && data.skills!.isNotEmpty
                        ? data.skills!
                            .map((s) => pw.Text('• ${s.name}'))
                            .toList()
                        : [pw.Text('Sem habilibdades registradas')]),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      'Contato',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('${data.personalInfo?.phone}'),
                    pw.SizedBox(height: 8),
                    ...(data.socials != null && data.socials!.isNotEmpty
                        ? data.socials!
                            .map((l) => pw.Text('${l.platform}: ${l.url}'))
                            .toList()
                        : [pw.Text('Sem redes sociais registrdas')]),
                  ],
                ),
              ),
              // Main
              pw.Expanded(
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(24),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Experiências',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      ...(data.experiences != null &&
                              data.experiences!.isNotEmpty
                          ? data.experiences!
                              .map(
                                (e) => pw.Padding(
                                  padding: pw.EdgeInsets.symmetric(vertical: 8),
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        '${e.position}',
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                      pw.Text(
                                        '${e.company} | ${e.startDate} - ${e.endDate}',
                                      ),
                                      pw.Text(e.description ?? ''),
                                    ],
                                  ),
                                ),
                              )
                              .toList()
                          : [pw.Text("Sem experiência registrada")]),
                      pw.Text(
                        'Graduação',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      ...(data.educations != null && data.educations!.isNotEmpty
                          ? data.educations!
                              .map(
                                (e) => pw.Padding(
                                  padding: pw.EdgeInsets.symmetric(vertical: 8),
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        '${e.degree}',
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                      pw.Text(
                                        '${e.school} | ${e.startDate} - ${e.endDate}',
                                      ),
                                      pw.Text(e.description ?? ''),
                                    ],
                                  ),
                                ),
                              )
                              .toList()
                          : [pw.Text("Sem graduações registradas")]),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    return doc;
  }

  @override
  String get id => 'modern_side';

  @override
  PlanType get minPlan => PlanType.premium;
}

class TimelineTemplate implements ResumeTemplate {
  @override
  String get displayName => 'Linha do Tempo';

  @override
  pw.Document buildPdf(ResumeData data, BuildContext context) {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '${data.personalInfo?.name}',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              ...(data.experiences != null && data.experiences!.isNotEmpty
                  ? data.experiences!
                      .map(
                        (e) => pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                '${e.position}',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                '${e.company} | ${e.startDate} - ${e.endDate}',
                              ),
                              pw.Text(e.description ?? ''),
                            ],
                          ),
                        ),
                      )
                      .toList()
                  : [pw.Text("Sem experiência registrada")]),
              pw.Text(
                'Graduação',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              ...(data.educations != null && data.educations!.isNotEmpty
                  ? data.educations!
                      .map(
                        (e) => pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                '${e.degree}',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                '${e.school} | ${e.startDate} - ${e.endDate}',
                              ),
                              pw.Text(e.description ?? ''),
                            ],
                          ),
                        ),
                      )
                      .toList()
                  : [pw.Text("Sem graduações registradas")]),
            ],
          );
        },
      ),
    );
    return doc;
  }

  @override
  String get id => 'timeline_template';

  @override
  PlanType get minPlan => PlanType.premium;
}

class InfographicTemplate implements ResumeTemplate {
  @override
  String get displayName => 'Infográfico Visual';

  @override
  pw.Document buildPdf(ResumeData data, BuildContext context) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Coluna Esquerda: Perfil e Skills
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 100,
                      height: 100,
                      decoration: const pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        color: PdfColors.grey300,
                      ),
                      alignment: pw.Alignment.center,
                      child: pw.Text("👤", style: pw.TextStyle(fontSize: 40)),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      '${data.personalInfo?.name}',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Contato",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('${data.personalInfo?.email}'),
                    pw.Text('${data.personalInfo?.phone}'),
                    for (var link in data.socials!)
                      pw.Text('${link.platform}: ${link.url}'),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      "Habilidades",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    ...data.skills!.map((skill) => _buildSkillBar(skill)),
                  ],
                ),
              ),

              pw.SizedBox(width: 24),

              // Coluna Direita: Objetivo, Experiências, Formação
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (data.objective != null && data.objective!.isNotEmpty)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Resumo",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text('${data.objective}'),
                          pw.SizedBox(height: 12),
                        ],
                      ),
                    if (data.experiences != null &&
                        data.experiences!.isNotEmpty)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Experiência Profissional",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 8),
                          ...data.experiences!.map(
                            (e) => _buildExperienceBlock(e),
                          ),
                        ],
                      ),
                    if (data.educations != null && data.educations!.isNotEmpty)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 16),
                          pw.Text(
                            "Formação Acadêmica",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 8),
                          ...data.educations!.map(
                            (e) => pw.Text(
                              "${e.startDate} - ${e.endDate ?? 'cursando'} ${e.degree} (${e.school})",
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildSkillBar(Skill skill) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('${skill.name}'),
        pw.SizedBox(height: 2),
        pw.Container(
          height: 6,
          width: 100,
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            borderRadius: pw.BorderRadius.circular(2),
          ),
          child: pw.Container(
            width: 75,
            decoration: pw.BoxDecoration(
              color: PdfColors.blue,
              borderRadius: pw.BorderRadius.circular(2),
            ),
          ),
        ),
        pw.SizedBox(height: 4),
      ],
    );
  }

  pw.Widget _buildExperienceBlock(dynamic exp) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "${exp.period} - ${exp.role} @ ${exp.company}",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          if (exp.description.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                exp.description,
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  @override
  String get id => 'info_graphic';

  @override
  PlanType get minPlan => PlanType.premium;
}

class CorporateTemplate implements ResumeTemplate {
  @override
  String get displayName => 'Corporativo Elegante';

  @override
  pw.Document buildPdf(ResumeData data, BuildContext context) {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '${data.personalInfo?.name}',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(data.objective ?? '', style: pw.TextStyle(fontSize: 12)),
              pw.Divider(),
              pw.Text(
                'Educação',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              ...data.educations!.map(
                (e) =>
                    pw.Text('\${e.degree}, \${e.institution} (\${e.period})'),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                'Experiências',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              ...data.experiences!.map(
                (e) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${e.position}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('\${e.company} | \${e.period}'),
                    pw.Text(e.description ?? ''),
                    pw.SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    return doc;
  }

  @override
  String get id => 'executive';

  @override
  PlanType get minPlan => PlanType.premium;
}

class TechDeveloper implements ResumeTemplate {
  @override
  pw.Document buildPdf(ResumeData data, BuildContext context) {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(data),
              pw.SizedBox(height: 16),
              _buildSectionTitle('Resumo Profissional'),
              if (data.objective != null && data.objective!.isNotEmpty)
                pw.Text(
                  '${data.objective}',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              pw.SizedBox(height: 16),
              _buildSectionTitle('Stacks & Tecnologias'),
              _buildSkillsGrid(data),
              pw.SizedBox(height: 16),
              _buildSectionTitle('Projetos'),
              ...data.projects!.map(_buildProjectItem),
              pw.SizedBox(height: 16),
              _buildSectionTitle('Experiência Profissional'),
              ...data.experiences!.map(_buildExperienceItem),
              pw.SizedBox(height: 16),
              _buildSectionTitle('Formação Acadêmica'),
              ...data.educations!.map(_buildEducationItem),
            ],
          );
        },
      ),
    );

    return doc;
  }

  pw.Widget _buildHeader(ResumeData resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '${resume.personalInfo!.name}',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '${resume.personalInfo!.email} | ${resume.personalInfo!.phone}',
          style: const pw.TextStyle(fontSize: 11),
        ),
        if (resume.socials != null && resume.socials!.isNotEmpty)
          ...resume.socials!.map(
            (e) => pw.Text(
              '${e.platform}: ${e.url}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue,
      ),
    );
  }

  pw.Widget _buildSkillsGrid(ResumeData resume) {
    return pw.Wrap(
      spacing: 6,
      runSpacing: 6,
      children:
          resume.skills!.map((s) {
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                '${s.name}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            );
          }).toList(),
    );
  }

  pw.Widget _buildProjectItem(Project p) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${p.name}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          if (p.technologies != null && p.technologies!.isNotEmpty)
            pw.Text(
              p.technologies!.join(', '),
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          if (p.description != null && p.description!.isNotEmpty)
            pw.Text(
              '${p.description}',
              style: const pw.TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildExperienceItem(Experience e) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${e.position}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            '${e.company} • ${e.startDate}-${e.endDate}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          if (e.description != null && e.description!.isNotEmpty)
            pw.Text(
              '${e.description}',
              style: const pw.TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildEducationItem(Education e) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        '${e.degree}, ${e.school} (${e.startDate}-${e.endDate})',
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  @override
  String get displayName => 'Desenvolvedor';

  @override
  String get id => 'tech_developer';

  @override
  PlanType get minPlan => PlanType.premium;
}

class StudantTemplate implements ResumeTemplate {
  @override
  pw.Document buildPdf(ResumeData data, BuildContext context) {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(data),
              pw.SizedBox(height: 12),
              if (data.objective!.isNotEmpty) ...[
                _buildSectionTitle('Sobre Mim'),
                pw.Text(
                  '${data.objective}',
                  style: const pw.TextStyle(fontSize: 11),
                ),
                pw.SizedBox(height: 12),
              ],
              if (data.educations!.isNotEmpty) ...[
                _buildSectionTitle('Educação'),
                ...data.educations!.map(_buildEducationItem),
                pw.SizedBox(height: 12),
              ],
              if (data.projects!.isNotEmpty) ...[
                _buildSectionTitle('Projetos Acadêmicos ou Pessoais'),
                ...data.projects!.map(_buildProjectItem),
                pw.SizedBox(height: 12),
              ],
              if (data.certificates!.isNotEmpty) ...[
                _buildSectionTitle('Certificações'),
                ...data.certificates!.map(_buildCertItem),
                pw.SizedBox(height: 12),
              ],
              if (data.skills!.isNotEmpty) ...[
                _buildSectionTitle('Habilidades'),
                _buildSkillChips(data),
              ],
            ],
          );
        },
      ),
    );

    return doc;
  }

  pw.Widget _buildHeader(ResumeData resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '${resume.personalInfo?.name}',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '${resume.personalInfo?.email} | ${resume.personalInfo?.phone}',
          style: const pw.TextStyle(fontSize: 11),
        ),
        if (resume.socials!.isNotEmpty)
          ...resume.socials!.map(
            (e) => pw.Text(
              '${e.platform}: ${e.url}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 13,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.indigo,
      ),
    );
  }

  pw.Widget _buildEducationItem(Education e) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${e.degree}, ${e.school}',
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.Text(
            '${e.startDate}-${e.endDate}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildProjectItem(Project p) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${p.name}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          if (p.technologies != null && p.technologies!.isNotEmpty)
            pw.Text(
              p.technologies!.join(', '),
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          if (p.description != null && p.description!.isNotEmpty)
            pw.Text(
              '${p.description}',
              style: const pw.TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildCertItem(Certificate c) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Text(
        '${c.institution} - ${c.courseName}',
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  pw.Widget _buildSkillChips(ResumeData resume) {
    return pw.Wrap(
      spacing: 6,
      runSpacing: 6,
      children:
          resume.skills!.map((s) {
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                '${s.name}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            );
          }).toList(),
    );
  }

  @override
  String get displayName => 'Primeiro emprego';

  @override
  String get id => 'studant';

  @override
  PlanType get minPlan => PlanType.free;
}

class InternationalTemplate implements ResumeTemplate {
  @override
  pw.Document buildPdf(ResumeData data, BuildContext context) {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(data),
              pw.SizedBox(height: 16),
              _buildSectionTitle('Profile'),
              if (data.objective!.isNotEmpty)
                pw.Text(
                  "${data.objective}",
                  style: const pw.TextStyle(fontSize: 11),
                ),
              pw.SizedBox(height: 16),
              _buildSectionTitle('Work Experience'),
              ...data.experiences!.map(_buildExperienceItem),
              pw.SizedBox(height: 16),
              _buildSectionTitle('Education'),
              ...data.educations!.map(_buildEducationItem),
              pw.SizedBox(height: 16),
              if (data.languages!.isNotEmpty) ...[
                _buildSectionTitle('Languages'),
                ...data.languages!.map(_buildLanguageItem),
                pw.SizedBox(height: 16),
              ],
              if (data.skills!.isNotEmpty) ...[
                _buildSectionTitle('Skills'),
                _buildSkillList(data.skills!),
              ],
            ],
          );
        },
      ),
    );

    return doc;
  }

  pw.Widget _buildHeader(ResumeData resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '${resume.personalInfo?.name}',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '${resume.personalInfo?.email} | ${resume.personalInfo?.phone}',
          style: const pw.TextStyle(fontSize: 11),
        ),
        if (resume.socials != null && resume.socials!.isNotEmpty)
          ...resume.socials!.map(
            (e) => pw.Text(
              '${e.platform}: ${e.url}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 13,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue,
      ),
    );
  }

  pw.Widget _buildExperienceItem(Experience e) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${e.position}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            '${e.company} • ${e.startDate}-${e.endDate}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          if (e.description!.isNotEmpty)
            pw.Text(
              '${e.description}',
              style: const pw.TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildEducationItem(Education e) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        '${e.degree}, ${e.school} (${e.startDate}-${e.endDate})',
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  pw.Widget _buildLanguageItem(Language l) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Text(
        '${l.language}: ${l.proficiencyLevel}',
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  pw.Widget _buildSkillList(List<Skill> skills) {
    return pw.Wrap(
      spacing: 6,
      runSpacing: 6,
      children:
          skills.map((s) {
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                '${s.name}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            );
          }).toList(),
    );
  }

  @override
  String get displayName => 'Internacional';

  @override
  String get id => 'international';

  @override
  PlanType get minPlan => PlanType.premium;
}
