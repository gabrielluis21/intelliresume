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
    ModernSidebarTemplate(),
    TimelineTemplate(),
    InfographicTemplate(),
    InfographicTemplate(),
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

  _buildProfileImage(String? picUrl) async {
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
  // TODO: implement id
  String get id => 'modern_side';

  @override
  // TODO: implement minPlan
  PlanType get minPlan => throw UnimplementedError();
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
  String get id => throw UnimplementedError();

  @override
  PlanType get minPlan => PlanType.premium;
}

class InfographicTemplate implements ResumeTemplate {
  @override
  String get displayName => 'Infográfico Visual';

  @override
  pw.Document buildPdf(ResumeData data, BuildContext context) {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(24),
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
              pw.SizedBox(height: 12),
              pw.Text(
                'Skills',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              ...data.skills!.map(
                (s) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('${s.name}'),
                    pw.Container(
                      height: 6,
                      width: double.infinity,
                      color: PdfColors.grey300,
                      child: pw.Container(
                        width:
                            (s.level != null ? int.parse(s.level!) : 0 / 100) *
                            PdfPageFormat.a4.availableWidth,
                        color: PdfColors.blue,
                      ),
                    ),
                    pw.SizedBox(height: 6),
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
  String get id => throw UnimplementedError();

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
  String get id => throw UnimplementedError();

  @override
  PlanType get minPlan => PlanType.premium;
}
