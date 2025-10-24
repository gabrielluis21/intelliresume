// TEMPLATE INTERFACE
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

abstract class ResumeTemplate {
  String get id;
  String displayName(AppLocalizations translated);
  PlanType get minPlan;

  /// Constrói o PDF. Pode receber um [targetLanguage] opcional para templates
  /// que suportam tradução automática.
  Future<pw.Document> buildPdf(
    ResumeData data,
    BuildContext context, {
    String? targetLanguage,
  });

  static final List<ResumeTemplate> allTemplates = [
    IntelliResumePatternTemplate(),
    ClassicMinimalTemplate(),
    StudantTemplate(),
    ModernSidebarTemplate(),
    TimelineTemplate(),
    InfographicTemplate(),
    InternationalTemplate(),
    TechDeveloper(),
    CorporateTemplate(),
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
  pw.Font? fontsLight;
  pw.Font? fontsRegular;
  pw.Font? fontsBold;

  Future<void> _loadFonts() async {
    fontsLight = await PdfGoogleFonts.nunitoSansLight();
    fontsRegular = await PdfGoogleFonts.nunitoSansRegular();
    fontsBold = await PdfGoogleFonts.nunitoSansBold();
  }

  @override
  Future<pw.Document> buildPdf(
    ResumeData data,
    BuildContext context, {
    String? targetLanguage,
  }) async {
    final pdf = pw.Document();
    final translated = AppLocalizations.of(context)!;

    await _loadFonts(); // Garante que as fontes estão carregadas
    final headerPdf = await _buildHeader(data); // Agora espera a imagem

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              headerPdf,
              _buildSection(
                translated.objective,
                data.objective ?? '',
                translated,
              ),
              _buildExperienceSection(data.experiences, translated),
              _buildEducationSection(data.educations, translated),
              _buildSkillsSection(data.skills, translated),
              _buildSocialsSection(data.socials, translated),
              _buildProjectsSection(data.projects, translated),
              _buildCertificatesSection(data.certificates, translated),
              data.includePCDInfo != false
                  ? _buildDisabilitySection(data, translated)
                  : pw.SizedBox.shrink(),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildProjectsSection(List<Project> projects, AppLocalizations t) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          t.projects,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        pw.SizedBox(height: 8),
        projects.isEmpty
            ? pw.Text(
              t.template_noProjects,
              style: pw.TextStyle(font: fontsRegular),
            )
            : _buildProjectList(projects, t),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildProjectList(List<Project> projects, AppLocalizations t) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (var proj in projects)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '- ${proj.name ?? ''} (${proj.startYear} - ${proj.endYear ?? t.template_current})',
                style: pw.TextStyle(font: fontsLight),
              ),
              if (proj.url != null && proj.url!.isNotEmpty)
                pw.Text(
                  '   ${proj.url!}',
                  style: pw.TextStyle(font: fontsLight, color: PdfColors.blue),
                ),
              if (proj.description?.isNotEmpty ?? false)
                pw.Text(
                  '   ${proj.description ?? ''}',
                  style: pw.TextStyle(font: fontsLight),
                ),
              pw.SizedBox(height: 8),
            ],
          ),
      ],
    );
  }

  pw.Widget _buildCertificatesSection(
    List<Certificate> certificates,
    AppLocalizations t,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          t.template_certificates,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        pw.SizedBox(height: 8),
        certificates.isEmpty
            ? pw.Text(
              t.template_noCertificates,
              style: pw.TextStyle(font: fontsRegular),
            )
            : _buildCertificateList(certificates),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildCertificateList(List<Certificate> certificates) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (var cert in certificates)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '- ${cert.courseName ?? ''} - ${cert.institution ?? ''}',
                style: pw.TextStyle(font: fontsLight),
              ),
              pw.Text(
                ' ${cert.startDate ?? ''} - ${cert.endDate ?? ''}',
                style: pw.TextStyle(font: fontsLight),
              ),
              if (cert.workload?.isNotEmpty ?? false)
                pw.Text(
                  cert.workload ?? '',
                  style: pw.TextStyle(font: fontsLight),
                ),
              pw.SizedBox(height: 8),
            ],
          ),
      ],
    );
  }

  @override
  String displayName(AppLocalizations translated) =>
      translated.template_defaultIntelliResume;

  Future<void> _buildProfileImage(String? picUrl) async {
    if (picUrl != null && picUrl.isNotEmpty && Uri.tryParse(picUrl) != null) {
      try {
        final uri = Uri.parse(picUrl);
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          _profileImage = pw.MemoryImage(response.bodyBytes);
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

  Future<pw.Widget> _buildHeader(ResumeData data) async {
    await _buildProfileImage(data.personalInfo?.profilePictureUrl);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _profileImage != null
            ? pw.Image(_profileImage, width: 100, height: 100)
            : pw.SizedBox.shrink(),
        pw.Text(
          data.personalInfo?.name ?? '',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          '${data.personalInfo?.email ?? ''} | ${data.personalInfo?.phone ?? ''}',
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildSection(
    String title,
    String disabilityDescription,
    AppLocalizations t,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          disabilityDescription.isNotEmpty
              ? disabilityDescription
              : t.noObjectives,
        ),
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
          t.experiences,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        pw.SizedBox(height: 8),
        experiences.isEmpty
            ? pw.Text(t.noExperience)
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
              pw.Text(
                '- ${exp.company ?? ''} - ${exp.position ?? ''}',
                style: pw.TextStyle(font: fontsLight),
              ),
              pw.Text(
                '   ${exp.startDate ?? ''} - ${exp.endDate ?? ''}',
                style: pw.TextStyle(font: fontsLight),
              ),
              pw.SizedBox(height: 8),
            ],
          ),
      ],
    );
  }

  pw.Widget _buildEducationSection(
    List<Education> educations,
    AppLocalizations translated,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          translated.educations,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        pw.SizedBox(height: 8),
        educations.isEmpty
            ? pw.Text(
              translated.noEducations,
              style: pw.TextStyle(font: fontsRegular),
            )
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
              pw.Text(
                '- ${edu.school ?? ''} - ${edu.degree ?? ''}',
                style: pw.TextStyle(font: fontsLight),
              ),
              pw.Text(
                '   ${edu.startDate ?? ''} - ${edu.endDate ?? ''}',
                style: pw.TextStyle(font: fontsLight),
              ),
              pw.SizedBox(height: 8),
            ],
          ),
      ],
    );
  }

  pw.Widget _buildSkillsSection(
    List<Skill> skills,
    AppLocalizations translated,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          translated.skills,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        pw.SizedBox(height: 8),
        skills.isEmpty
            ? pw.Text(
              translated.noSkill,
              style: pw.TextStyle(font: fontsRegular),
            )
            : _buildSkillList(skills),
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
                  '- ${skill.name ?? ''} (${skill.level ?? ''})',
                  style: pw.TextStyle(fontSize: 12, font: fontsLight),
                ),
              )
              .toList(),
    );
  }

  pw.Widget _buildSocialsSection(
    List<Social> socials,
    AppLocalizations translated,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          translated.template_socialLinks,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        socials.isEmpty
            ? pw.Text(
              translated.noSocialLink,
              style: pw.TextStyle(font: fontsRegular),
            )
            : _buildSocialList(socials),
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
                  '- ${social.platform ?? ''} (${social.url ?? ''})',
                  style: pw.TextStyle(fontSize: 12, font: fontsLight),
                ),
              )
              .toList(),
    );
  }

  pw.Widget _buildDisabilitySection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    final content = data.personalInfo?.pcdInfo;
    if (content == null) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          translated.template_additionalInfo,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          content.disabilityDescription ?? '',
          style: pw.TextStyle(font: fontsRegular),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  @override
  String get id => 'intelliresume_pattern';

  @override
  PlanType get minPlan => PlanType.free;
}

// TEMPLATES IMPLEMENTADOS
class ClassicMinimalTemplate implements ResumeTemplate {
  @override
  String displayName(AppLocalizations translated) =>
      translated.template_classicMinimalist;

  pw.Font? fontsLight;
  pw.Font? fontsRegular;
  pw.Font? fontsBold;

  Future<void> _loadFonts() async {
    fontsLight = await PdfGoogleFonts.nunitoSansLight();
    fontsRegular = await PdfGoogleFonts.nunitoSansRegular();
    fontsBold = await PdfGoogleFonts.nunitoSansBold();
  }

  @override
  Future<pw.Document> buildPdf(
    ResumeData data,
    BuildContext context, {
    String? targetLanguage,
  }) async {
    await _loadFonts();
    final doc = pw.Document();
    final t = AppLocalizations.of(context)!;
    doc.addPage(
      pw.Page(
        theme: pw.ThemeData(),
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                data.personalInfo?.name ?? '',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                  font: fontsBold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '${data.personalInfo?.email ?? ''} | ${data.personalInfo?.phone ?? ''}',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: fontsRegular, fontSize: 11),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                t.template_objective,
                style: pw.TextStyle(
                  fontSize: 18,
                  font: fontsBold,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                data.objective ?? t.template_objective,
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 24),
              pw.Text(
                t.experiences,
                style: pw.TextStyle(
                  font: fontsBold,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              ...((data.projects).isNotEmpty
                  ? (data.projects)
                      .map(
                        (p) => pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                p.name ?? '',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontsBold,
                                ),
                              ),
                              pw.Text(
                                '${p.startYear} - ${p.endYear}',
                                style: pw.TextStyle(font: fontsLight),
                              ),
                              pw.Text(
                                p.description ?? '',
                                style: pw.TextStyle(font: fontsRegular),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList()
                  : [pw.Text(t.template_noProjects)]),
              pw.Text(
                t.template_graduation,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: fontsBold,
                ),
              ),
              ...((data.educations).isNotEmpty
                  ? (data.educations)
                      .map(
                        (e) => pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                e.degree ?? '',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontsBold,
                                ),
                              ),
                              pw.Text(
                                '${e.school ?? ''} | ${e.startDate ?? ''} - ${e.endDate ?? ''}',
                                style: pw.TextStyle(font: fontsLight),
                              ),
                              pw.Text(
                                e.description ?? '',
                                style: pw.TextStyle(font: fontsRegular),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList()
                  : [pw.Text(t.template_noGraduationsRegistered)]),
              pw.SizedBox(height: 12),
              pw.Text(
                t.template_skills,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              ...((data.skills).isNotEmpty
                  ? (data.skills)
                      .map((s) => pw.Text('• ${s.name ?? ''}'))
                      .toList()
                  : [pw.Text(t.template_noSkillsRegistered)]),
              pw.SizedBox(height: 12),
              _buildProjectsSection(data, t),
              pw.SizedBox(height: 12),
              _buildCertificatesSection(data, t),
              pw.SizedBox(height: 12),
              _buildDisabilitySection(data, t),
            ],
          );
        },
      ),
    );
    return doc;
  }

  pw.Widget _buildProjectsSection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    if (data.projects == null || data.projects.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          translated.template_projects,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
            fontSize: 18,
          ),
        ),
        ...data.projects.map(
          (p) => pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  p.name ?? '',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    font: fontsBold,
                  ),
                ),
                pw.Text(
                  '${p.startYear} - ${p.endYear}',
                  style: pw.TextStyle(font: fontsLight),
                ),
                pw.Text(
                  p.description ?? '',
                  style: pw.TextStyle(font: fontsRegular),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildCertificatesSection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    if (data.certificates == null || data.certificates.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          translated.template_certificates,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
            fontSize: 18,
          ),
        ),
        ...data.certificates.map(
          (c) => pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  c.courseName ?? '',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    font: fontsBold,
                  ),
                ),
                pw.Text(
                  '${c.institution} | ${c.startDate} - ${c.endDate}',
                  style: pw.TextStyle(font: fontsLight),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildDisabilitySection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    final content = data.personalInfo?.pcdInfo;
    if (content == null) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 12),
        pw.Text(
          translated.template_additionalInfo,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
            fontSize: 18,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          content.disabilityDescription ?? '',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: fontsRegular),
        ),
      ],
    );
  }

  @override
  String get id => 'classic';

  @override
  PlanType get minPlan => PlanType.free;
}

class ModernSidebarTemplate implements ResumeTemplate {
  @override
  String displayName(AppLocalizations translated) =>
      translated.template_modernSidebar;

  pw.Font? fontsLight;
  pw.Font? fontsRegular;
  pw.Font? fontsBold;

  Future<void> _loadFonts() async {
    fontsLight = await PdfGoogleFonts.nunitoSansLight();
    fontsRegular = await PdfGoogleFonts.nunitoSansRegular();
    fontsBold = await PdfGoogleFonts.nunitoSansBold();
  }

  /// Builds the left sidebar widget.
  pw.Widget _buildSidebar(
    ResumeData resumeData,
    pw.Font ttf,
    PdfColor sidebarColor,
    PdfColor textColor,
    AppLocalizations translated,
  ) {
    final skills = resumeData.skills;

    return pw.Container(
      width: 210, // A4 width is 595, this is roughly 35%
      color: sidebarColor,
      padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            resumeData.personalInfo?.name?.toUpperCase() ??
                translated.template_yourName,
            style: pw.TextStyle(
              color: textColor,
              fontSize: 26,
              fontWeight: pw.FontWeight.bold,
              height: 1.2,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Container(height: 2, width: 50, color: textColor),
          pw.SizedBox(height: 40),
          _buildSidebarInfo(
            resumeData.personalInfo?.email,
            textColor,
            translated,
          ),
          _buildSidebarInfo(
            resumeData.personalInfo?.phone,
            textColor,
            translated,
          ),
          // The cv_data model does not have an address field in UserProfile.
          // Add it to your model or use a placeholder if needed.
          // _buildSidebarInfo('Your City, Country', textColor),
          pw.Spacer(),
          if (skills != null && skills.isNotEmpty) ...[
            pw.Text(
              translated.template_skills,
              style: pw.TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children:
                  skills
                      .map(
                        (skill) => pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 5),
                          child: pw.Text(
                            '• ${skill.name ?? ''}',
                            style: pw.TextStyle(
                              color: textColor.shade(0.85),
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the main content area on the right.
  pw.Widget _buildMainContent(
    ResumeData resumeData,
    pw.Font ttf,
    AppLocalizations translated,
  ) {
    return pw.Expanded(
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Profile Section
            if (resumeData.about?.isNotEmpty ?? false) ...[
              _buildSectionTitle(translated.template_profile),
              pw.Text(
                resumeData.about!,
                style: const pw.TextStyle(fontSize: 10.5, height: 1.6),
                textAlign: pw.TextAlign.justify,
              ),
              pw.SizedBox(height: 24),
            ],
            // Experience Section
            if (resumeData.experiences != null &&
                resumeData.experiences.isNotEmpty) ...[
              _buildSectionTitle(translated.template_experience),
              ...resumeData.experiences.map(
                (exp) => _buildExperienceItem(
                  title:
                      exp.position?.toUpperCase() ??
                      translated.template_jobTitle,
                  subtitle:
                      '${exp.company ?? translated.template_company} | ${exp.startDate ?? ''} - ${exp.endDate ?? translated.template_present}',
                  description: exp.description,
                ),
              ),
            ],
            // Education Section
            if (resumeData.educations != null &&
                resumeData.educations.isNotEmpty) ...[
              _buildSectionTitle(translated.template_education),
              ...resumeData.educations.map(
                (edu) => _buildExperienceItem(
                  title:
                      edu.degree?.toUpperCase() ??
                      translated.template_degreeCourse,
                  subtitle:
                      '${edu.school ?? translated.template_institution} | ${edu.startDate ?? ''} - ${edu.endDate ?? ''}',
                  description: edu.description,
                ),
              ),
            ],
            // Projects Section
            if (resumeData.projects != null &&
                resumeData.projects.isNotEmpty) ...[
              _buildSectionTitle(translated.template_projects),
              ...resumeData.projects.map(
                (proj) => _buildExperienceItem(
                  title:
                      proj.name?.toUpperCase() ??
                      translated.template_projectName,
                  subtitle:
                      '${proj.startYear ?? ''} - ${proj.endYear ?? translated.template_present}',
                  description: proj.description,
                ),
              ),
            ],
            // Certificates Section
            if (resumeData.certificates != null &&
                resumeData.certificates.isNotEmpty) ...[
              _buildSectionTitle(translated.template_certificates),
              ...resumeData.certificates.map(
                (cert) => _buildExperienceItem(
                  title:
                      cert.courseName?.toUpperCase() ??
                      translated.template_certificateName,
                  subtitle:
                      '${cert.institution ?? 'Institution'} | ${cert.startDate ?? ''} - ${cert.endDate ?? ''}',
                  description: cert.workload,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper to build a line of info in the sidebar.
  pw.Widget _buildSidebarInfo(
    String? text,
    PdfColor color,
    AppLocalizations translated,
  ) {
    if (text == null || text.isEmpty) return pw.SizedBox.shrink();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(color: color.shade(0.85), fontSize: 10.5),
      ),
    );
  }

  /// Helper to build a section title with a divider.
  pw.Widget _buildSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Divider(height: 1, thickness: 1, color: PdfColors.grey300),
        pw.SizedBox(height: 16),
      ],
    );
  }

  /// Helper to build an item for Experience or Education sections.
  pw.Widget _buildExperienceItem({
    required String title,
    required String subtitle,
    String? description,
  }) {
    final points =
        description?.split('\n').where((s) => s.trim().isNotEmpty).toList() ??
        [];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          subtitle,
          style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
        ),
        if (points.isNotEmpty) pw.SizedBox(height: 10),
        ...points.map(
          (point) => pw.Container(
            padding: const pw.EdgeInsets.only(left: 8, bottom: 5),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('•', style: const pw.TextStyle(fontSize: 11)),
                pw.SizedBox(width: 5),
                pw.Expanded(
                  child: pw.Text(
                    point.trim(),
                    textAlign: pw.TextAlign.justify,
                    style: const pw.TextStyle(fontSize: 10.5, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  @override
  Future<pw.Document> buildPdf(
    ResumeData data,
    BuildContext context, {
    String? targetLanguage,
  }) async {
    await _loadFonts();
    final pdf = pw.Document();
    final translated = AppLocalizations.of(context)!;
    final sidebarColor = PdfColor.fromHex('#2C2A63');
    final textColor = PdfColors.white;

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: fontsRegular, bold: fontsBold),
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Row(
            children: [
              // Left Sidebar
              _buildSidebar(
                data,
                fontsRegular!,
                sidebarColor,
                textColor,
                translated,
              ),
              // Right Main Content
              _buildMainContent(data, fontsRegular!, translated),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  @override
  String get id => 'modern_with_sidebar';

  @override
  PlanType get minPlan => PlanType.premium;
}

class TimelineTemplate implements ResumeTemplate {
  @override
  String displayName(AppLocalizations translated) =>
      translated.template_timeline;

  pw.Font? fontsLight;
  pw.Font? fontsRegular;
  pw.Font? fontsBold;

  Future<void> _loadFonts() async {
    fontsLight = await PdfGoogleFonts.nunitoSansLight();
    fontsRegular = await PdfGoogleFonts.nunitoSansRegular();
    fontsBold = await PdfGoogleFonts.nunitoSansBold();
  }

  @override
  Future<pw.Document> buildPdf(
    ResumeData data,
    BuildContext context, {
    String? targetLanguage,
  }) async {
    await _loadFonts();
    final doc = pw.Document();
    final translated = AppLocalizations.of(context)!;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                data.personalInfo?.name ?? '',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  font: fontsBold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '${data.personalInfo?.email ?? ''} | ${data.personalInfo?.phone ?? ''}',
                style: pw.TextStyle(font: fontsRegular, fontSize: 12),
              ),
              pw.SizedBox(height: 16),
              ...((data.experiences).isNotEmpty
                  ? (data.experiences)
                      .map(
                        (e) => pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                e.position ?? '',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                '${e.company ?? ''} | ${e.startDate ?? ''} - ${e.endDate ?? ''}',
                              ),
                              pw.Text(e.description ?? ''),
                            ],
                          ),
                        ),
                      )
                      .toList()
                  : [pw.Text(translated.template_noExperienceRegistered)]),
              pw.Text(
                translated.template_graduation,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: fontsBold,
                ),
              ),
              ...((data.educations).isNotEmpty
                  ? (data.educations)
                      .map(
                        (e) => pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                e.degree ?? '',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontsBold,
                                ),
                              ),
                              pw.Text(
                                '${e.school ?? ''} | ${e.startDate ?? ''} - ${e.endDate ?? ''}',
                              ),
                              pw.Text(e.description ?? ''),
                            ],
                          ),
                        ),
                      )
                      .toList()
                  : [pw.Text(translated.template_noGraduationsRegistered)]),
              _buildProjectsSection(data, translated),
              _buildCertificatesSection(data, translated),
              _buildDisabilitySection(data, translated),
            ],
          );
        },
      ),
    );
    return doc;
  }

  pw.Widget _buildProjectsSection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    if (data.projects == null || data.projects.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        pw.Text(
          translated.template_projects,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        ...data.projects.map(
          (p) => pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  p.name ?? '',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text('${p.startYear} - ${p.endYear}'),
                pw.Text(p.description ?? ''),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildCertificatesSection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    if (data.certificates == null || data.certificates.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        pw.Text(
          translated.template_certificates,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        ...data.certificates.map(
          (c) => pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  c.courseName ?? '',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text('${c.institution} | ${c.startDate} - ${c.endDate}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildDisabilitySection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    final content = data.personalInfo?.pcdInfo;
    if (content == null) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        pw.Text(
          translated.template_additionalInfo,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          content.disabilityDescription ?? '',
          style: pw.TextStyle(font: fontsRegular),
        ),
      ],
    );
  }

  @override
  String get id => 'timeline';

  @override
  PlanType get minPlan => PlanType.premium;
}

class InfographicTemplate implements ResumeTemplate {
  @override
  String displayName(AppLocalizations translated) =>
      translated.template_visualInfographic;

  pw.Font? fontsLight;
  pw.Font? fontsRegular;
  pw.Font? fontsBold;

  Future<void> _loadFonts() async {
    fontsLight = await PdfGoogleFonts.nunitoSansLight();
    fontsRegular = await PdfGoogleFonts.nunitoSansRegular();
    fontsBold = await PdfGoogleFonts.nunitoSansBold();
  }

  @override
  Future<pw.Document> buildPdf(
    ResumeData data,
    BuildContext context, {
    String? targetLanguage,
  }) async {
    final pdf = pw.Document();
    final translated = AppLocalizations.of(context)!;
    await _loadFonts();

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
                      data.personalInfo?.name ?? '',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        font: fontsBold,
                      ),
                    ),
                    pw.Text(
                      translated.template_contact,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        font: fontsBold,
                      ),
                    ),
                    pw.Text(data.personalInfo?.email ?? ''),
                    pw.Text(data.personalInfo?.phone ?? ''),
                    for (var link in data.socials)
                      pw.Text('${link.platform ?? ''}: ${link.url ?? ''}'),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      translated.template_skills,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        font: fontsBold,
                      ),
                    ),
                    ...(data.skills).map(
                      (skill) => _buildSkillBar(skill, translated),
                    ),
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
                    if (data.objective?.isNotEmpty ?? false)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            translated.template_summary,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: fontsBold,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(data.objective ?? ''),
                          pw.SizedBox(height: 12),
                        ],
                      ),
                    if (data.experiences.isNotEmpty)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            translated.template_professionalExperience,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: fontsBold,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          ...(data.experiences).map(
                            (e) => _buildExperienceBlock(e),
                          ),
                        ],
                      ),
                    if ((data.educations).isNotEmpty)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 16),
                          pw.Text(
                            translated.template_academicBackground,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: fontsBold,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          ...(data.educations).map(
                            (e) => pw.Text(
                              "${e.startDate ?? ''} - ${e.endDate ?? translated.template_ongoing} ${e.degree ?? ''} (${e.school ?? ''})",
                            ),
                          ),
                        ],
                      ),
                    if ((data.projects).isNotEmpty)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 16),
                          pw.Text(
                            translated.template_projects,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: fontsBold,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          ...(data.projects).map(
                            (p) => _buildExperienceBlock(
                              Experience(
                                company: p.name,
                                startDate: p.startYear,
                                endDate: p.endYear,
                                description: p.description,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if ((data.certificates).isNotEmpty)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 16),
                          pw.Text(
                            translated.template_certificates,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: fontsBold,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          ...(data.certificates).map(
                            (c) => pw.Text(
                              "${c.courseName ?? ''} - ${c.institution ?? ''} (${c.startDate ?? ''} - ${c.endDate ?? ''})",
                            ),
                          ),
                        ],
                      ),
                    _buildDisabilitySection(data, translated),
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

  pw.Widget _buildDisabilitySection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    final content = data.personalInfo?.pcdInfo;
    if (content == null) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        pw.Text(
          translated.template_additionalInfo,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontsBold),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          content.disabilityDescription ?? '',
          style: pw.TextStyle(font: fontsRegular),
        ),
      ],
    );
  }

  pw.Widget _buildSkillBar(Skill skill, AppLocalizations translated) {
    // Helper para converter o nível em uma largura proporcional
    double getSkillWidth(String? level) {
      const maxWidth = 100.0; // A largura total da barra de fundo
      if (level == translated.template_beginner) {
        return maxWidth * 0.25;
      } else if (level == translated.template_basic) {
        return maxWidth * 0.4;
      } else if (level == translated.template_intermediate) {
        return maxWidth * 0.65;
      } else if (level == translated.template_advanced) {
        return maxWidth * 0.85;
      } else if (level == translated.template_fluent) {
        return maxWidth * 1.0;
      } else {
        return maxWidth * 0.5; // Padrão para valores inesperados
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(skill.name ?? ''),
        pw.SizedBox(height: 2),
        pw.Container(
          height: 6,
          width: 100,
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            borderRadius: pw.BorderRadius.circular(2),
          ),
          child: pw.Container(
            width: getSkillWidth(skill.level), // Largura dinâmica aqui
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

  pw.Widget _buildExperienceBlock(Experience exp) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "${exp.startDate ?? ''} - ${exp.endDate ?? ''} - ${exp.position ?? ''} @ ${exp.company ?? ''}",
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              font: fontsBold,
            ),
          ),
          if (exp.description?.isNotEmpty ?? false)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                exp.description ?? '',
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  @override
  String get id => 'infographic';

  @override
  PlanType get minPlan => PlanType.premium;
}

class CorporateTemplate implements ResumeTemplate {
  @override
  String displayName(AppLocalizations translated) =>
      translated.template_elegantCorporate;

  pw.Font? fontsLight;
  pw.Font? fontsRegular;
  pw.Font? fontsBold;

  Future<void> _loadFonts() async {
    fontsLight = await PdfGoogleFonts.nunitoSansLight();
    fontsRegular = await PdfGoogleFonts.nunitoSansRegular();
    fontsBold = await PdfGoogleFonts.nunitoSansBold();
  }

  @override
  Future<pw.Document> buildPdf(
    ResumeData data,
    BuildContext context, {
    String? targetLanguage,
  }) async {
    await _loadFonts();
    final doc = pw.Document();
    final translated = AppLocalizations.of(context)!;
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                data.personalInfo?.name ?? '',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  font: fontsBold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '${data.personalInfo?.email ?? ''} | ${data.personalInfo?.phone ?? ''}',
                style: pw.TextStyle(font: fontsRegular, fontSize: 11),
              ),
              pw.SizedBox(height: 8),
              pw.Text(data.objective ?? '', style: pw.TextStyle(fontSize: 12)),
              pw.Divider(),
              pw.Text(
                translated.template_education,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: fontsBold,
                ),
              ),
              ...(data.educations).map(
                (e) => pw.Text(
                  '${e.degree ?? ''}, ${e.school ?? ''} (${e.startDate ?? ''} - ${e.endDate ?? ''})',
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                translated.template_experience,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: fontsBold,
                ),
              ),
              ...(data.experiences).map(
                (e) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      e.position ?? '',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        font: fontsBold,
                      ),
                    ),
                    pw.Text(
                      '${e.company ?? ''} | ${e.startDate ?? ''} - ${e.endDate ?? ''}',
                    ),
                    pw.Text(e.description ?? ''),
                    pw.SizedBox(height: 8),
                  ],
                ),
              ),
              _buildProjectsSection(data, translated),
              _buildCertificatesSection(data, translated),
              _buildDisabilitySection(data, translated),
            ],
          );
        },
      ),
    );
    return doc;
  }

  pw.Widget _buildProjectsSection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    if (data.projects == null || data.projects.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),
        pw.Text(
          translated.template_projects,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontsBold),
        ),
        ...data.projects.map(
          (p) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                p.name ?? '',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: fontsBold,
                ),
              ),
              pw.Text('${p.startYear} - ${p.endYear}'),
              pw.Text(p.description ?? ''),
              pw.SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildCertificatesSection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    if (data.certificates == null || data.certificates.isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),
        pw.Text(
          translated.template_certificates,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontsBold),
        ),
        ...data.certificates.map(
          (c) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                c.courseName ?? '',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: fontsBold,
                ),
              ),
              pw.Text('${c.institution} | ${c.startDate} - ${c.endDate}'),
              pw.SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildDisabilitySection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    final content = data.personalInfo?.pcdInfo;
    if (content == null) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),
        pw.Divider(),
        pw.SizedBox(height: 12),
        pw.Text(
          translated.template_additionalInfo,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fontsBold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          content.disabilityDescription ?? '',
          style: pw.TextStyle(font: fontsRegular),
        ),
      ],
    );
  }

  @override
  String get id => 'executive';

  @override
  PlanType get minPlan => PlanType.premium;
}

class TechDeveloper implements ResumeTemplate {
  pw.Font? fontsLight;
  pw.Font? fontsRegular;
  pw.Font? fontsBold;

  Future<void> _loadFonts() async {
    fontsLight = await PdfGoogleFonts.nunitoSansLight();
    fontsRegular = await PdfGoogleFonts.nunitoSansRegular();
    fontsBold = await PdfGoogleFonts.nunitoSansBold();
  }

  @override
  Future<pw.Document> buildPdf(
    ResumeData data,
    BuildContext context, {
    String? targetLanguage,
  }) async {
    await _loadFonts();
    final doc = pw.Document();
    final translated = AppLocalizations.of(context)!;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(data, translated),
              pw.SizedBox(height: 16),
              _buildSectionTitle(translated.template_professionalSummary),
              if (data.objective?.isNotEmpty ?? false)
                pw.Text(
                  data.objective ?? '',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              pw.SizedBox(height: 16),
              _buildSectionTitle(translated.template_stacksTechnologies),
              _buildSkillsGrid(data, translated),
              pw.SizedBox(height: 16),
              _buildSectionTitle(translated.template_projects),
              if (data.projects.isNotEmpty)
                pw.Wrap(
                  children: data.projects.map(_buildProjectItem).toList(),
                ),
              pw.SizedBox(height: 16),
              _buildSectionTitle(translated.template_professionalExperience),
              if (data.experiences.isNotEmpty)
                pw.Wrap(
                  children: data.experiences.map(_buildExperienceItem).toList(),
                ),
              pw.SizedBox(height: 16),
              _buildSectionTitle(translated.template_academicBackground),
              if (data.educations.isNotEmpty)
                pw.Wrap(
                  children: data.educations.map(_buildEducationItem).toList(),
                ),
              pw.SizedBox(height: 16),
              _buildSectionTitle(translated.template_certificates),
              if (data.certificates.isNotEmpty)
                pw.Wrap(
                  children:
                      data.certificates.map(_buildCertificateItem).toList(),
                ),
              _buildDisabilitySection(data, translated),
            ],
          );
        },
      ),
    );

    return doc;
  }

  pw.Widget _buildCertificateItem(Certificate c) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        '${c.courseName ?? ''}, ${c.institution ?? ''} (${c.startDate ?? ''}-${c.endDate ?? ''})',
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  pw.Widget _buildHeader(ResumeData resume, AppLocalizations translated) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          resume.personalInfo?.name ?? translated.template_nameNotFound,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '${resume.personalInfo?.email ?? ''} | ${resume.personalInfo?.phone ?? ''}',
          style: const pw.TextStyle(fontSize: 11),
        ),
        if (resume.socials.isNotEmpty)
          ...(resume.socials).map(
            (e) => pw.Text(
              '${e.platform ?? ''}: ${e.url ?? ''}',
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
        font: fontsBold,
        color: PdfColors.blue,
      ),
    );
  }

  pw.Widget _buildSkillsGrid(ResumeData resume, AppLocalizations translated) {
    return resume.skills.isEmpty
        ? pw.Text(translated.template_noSkillAdded)
        : pw.Wrap(
          spacing: 6,
          runSpacing: 6,
          children:
              resume.skills.map((s) {
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
                    s.name ?? '',
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
            p.name ?? '',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              font: fontsBold,
            ),
          ),
          if (p.url?.isNotEmpty ?? false)
            pw.Text(
              p.url ?? '',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.blue),
            ),
          if (p.description?.isNotEmpty ?? false)
            pw.Text(
              p.description ?? '',
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
            e.position ?? '',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              font: fontsBold,
            ),
          ),
          pw.Text(
            '${e.company ?? ''} • ${e.startDate ?? ''}-${e.endDate ?? ''}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          if (e.description?.isNotEmpty ?? false)
            pw.Text(
              e.description ?? '',
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
        '${e.degree ?? ''}, ${e.school ?? ''} (${e.startDate ?? ''}-${e.endDate ?? ''})',
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  pw.Widget _buildDisabilitySection(
    ResumeData data,
    AppLocalizations translated,
  ) {
    final content = data.personalInfo?.pcdInfo;
    if (content == null) {
      return pw.SizedBox.shrink();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        _buildSectionTitle(translated.template_additionalInfo),
        pw.SizedBox(height: 4),
        pw.Text(
          content.disabilityDescription ?? '',
          style: pw.TextStyle(font: fontsRegular),
        ),
      ],
    );
  }

  @override
  String displayName(AppLocalizations translated) =>
      translated.template_developer;

  @override
  String get id => 'dev_tec';

  @override
  PlanType get minPlan => PlanType.premium;
}

class StudantTemplate implements ResumeTemplate {
  pw.Font? fontsLight;
  pw.Font? fontsRegular;
  pw.Font? fontsBold;

  Future<void> _loadFonts() async {
    fontsLight = await PdfGoogleFonts.nunitoSansLight();
    fontsRegular = await PdfGoogleFonts.nunitoSansRegular();
    fontsBold = await PdfGoogleFonts.nunitoSansBold();
  }

  @override
  Future<pw.Document> buildPdf(
    ResumeData resumeData,
    BuildContext context, {
    String? targetLanguage,
  }) async {
    await _loadFonts();
    final pdf = pw.Document();
    final translated = AppLocalizations.of(context)!;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(resumeData, translated),
              pw.SizedBox(height: 20),

              // --- CONTEÚDO PRINCIPAL (DUAS COLUNAS) ---
              pw.Expanded(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // --- COLUNA DA ESQUERDA ---
                    pw.Expanded(
                      flex: 5,
                      child: _buildLeftColumn(resumeData, translated),
                    ),
                    pw.SizedBox(width: 30),

                    // --- COLUNA DA DIREITA ---
                    pw.Expanded(
                      flex: 5,
                      child: _buildRightColumn(resumeData, translated),
                    ),
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

  pw.Widget _buildHeader(ResumeData data, AppLocalizations translated) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          data.personalInfo?.name ?? translated.template_nameNotFound,
          style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          // Usando o campo "objetivo" como subtítulo, conforme o design.
          data.objective ?? translated.template_softwareEngineeringStudent,
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
      ],
    );
  }

  pw.Widget _buildLeftColumn(ResumeData data, AppLocalizations translated) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // --- SEÇÃO EDUCAÇÃO ---
        _buildSectionTitle(translated.template_education),
        ...(data.educations != null && data.educations.isNotEmpty
            ? data.educations.map(
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
            : [pw.Text(translated.template_noExperience)]),
        pw.SizedBox(height: 20),

        // --- SEÇÃO CURSOS (Exemplo estático) ---
        _buildSectionTitle(translated.template_courses),
        data.certificates == null || data.certificates.isEmpty
            ? pw.Text(translated.template_noCertificatesRegistered)
            : pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children:
                  data.certificates
                      .map(
                        (cert) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              cert.courseName ?? '',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(cert.institution ?? ''),
                            pw.Text('${cert.startDate} - ${cert.endDate}'),
                            if (cert.workload?.isNotEmpty ?? false)
                              pw.Text(
                                '${translated.template_workload} ${cert.workload}',
                              ),
                            pw.SizedBox(height: 10),
                          ],
                        ),
                      )
                      .toList(),
            ),
        pw.SizedBox(height: 20),

        // --- SEÇÃO HABILIDADES ---
        _buildSectionTitle(translated.template_skills),
        data.skills == null || data.skills.isEmpty
            ? pw.Text(translated.template_noSkills)
            : pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  data.skills
                      .map((skill) => _buildSkillChip(skill.name!))
                      .toList(),
            ),
      ],
    );
  }

  pw.Widget _buildRightColumn(ResumeData data, AppLocalizations translated) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // --- SEÇÃO PROJETOS ---
        _buildSectionTitle(translated.template_projects),
        ...(data.projects != null && data.projects.isNotEmpty
            ? data.projects.map(
              (proj) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    proj.name ?? '',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    '${proj.startYear} - ${proj.endYear}',
                    style: const pw.TextStyle(color: PdfColors.grey600),
                  ),
                  if (proj.url?.isNotEmpty ?? false) pw.Text(proj.url ?? ''),
                  pw.Text(proj.description ?? ''),
                  pw.SizedBox(height: 10),
                ],
              ),
            )
            : [pw.Text(translated.template_noProjectsRegistered)]),
        pw.SizedBox(height: 20),

        // --- SEÇÃO SOBRE MIM ---
        _buildSectionTitle(translated.template_aboutMe),
        pw.Text(data.objective ?? translated.template_aboutMeDefault),
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

  @override
  String displayName(AppLocalizations translated) =>
      translated.template_firstJob;

  @override
  String get id => 'studant_first_job';

  @override
  PlanType get minPlan => PlanType.free;
}

class InternationalTemplate implements ResumeTemplate {
  pw.Font? fontsLight;
  pw.Font? fontsRegular;
  pw.Font? fontsBold;

  Future<void> _loadFonts() async {
    fontsLight = await PdfGoogleFonts.nunitoSansLight();
    fontsRegular = await PdfGoogleFonts.nunitoSansRegular();
    fontsBold = await PdfGoogleFonts.nunitoSansBold();
  }

  @override
  Future<pw.Document> buildPdf(
    ResumeData data,
    BuildContext context, {
    String? targetLanguage,
  }) async {
    await _loadFonts();

    final ResumeData dataToBuild = data;
    final translated = AppLocalizations.of(context)!;

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(dataToBuild),
              pw.SizedBox(height: 16),
              _buildSectionTitle(translated.template_profile),
              if ((dataToBuild.objective ?? '').isNotEmpty)
                pw.Text(
                  dataToBuild.objective ?? '',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              pw.SizedBox(height: 16),
              _buildSectionTitle(translated.template_workExperience),
              ...(dataToBuild.experiences).map(_buildExperienceItem),
              pw.SizedBox(height: 16),
              _buildSectionTitle(translated.template_education),
              ...(dataToBuild.educations).map(_buildEducationItem),
              pw.SizedBox(height: 16),
              if ((dataToBuild.languages).isNotEmpty) ...[
                _buildSectionTitle(translated.template_languages),
                ...(dataToBuild.languages).map(_buildLanguageItem),
                pw.SizedBox(height: 16),
              ],
              if ((dataToBuild.skills).isNotEmpty) ...[
                _buildSectionTitle(translated.template_skills),
                _buildSkillList(dataToBuild.skills),
              ],
              pw.SizedBox(height: 16),
              if ((dataToBuild.projects).isNotEmpty) ...[
                _buildSectionTitle(translated.template_projects),
                ...(dataToBuild.projects).map(_buildProjectItem),
                pw.SizedBox(height: 16),
              ],
              if ((dataToBuild.certificates).isNotEmpty) ...[
                _buildSectionTitle(translated.template_certificates),
                ...(dataToBuild.certificates).map(_buildCertificateItem),
                pw.SizedBox(height: 16),
              ],
            ],
          );
        },
      ),
    );

    return doc;
  }

  pw.Widget _buildProjectItem(Project p) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            p.name ?? '',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              font: fontsBold,
            ),
          ),
          pw.Text(
            '${p.startYear ?? ''}-${p.endYear ?? ''}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          if ((p.description ?? '').isNotEmpty)
            pw.Text(
              p.description ?? '',
              style: const pw.TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildCertificateItem(Certificate c) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        '${c.courseName ?? ''}, ${c.institution ?? ''} (${c.startDate ?? ''}-${c.endDate ?? ''})',
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  pw.Widget _buildHeader(ResumeData resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          resume.personalInfo?.name ?? '',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            font: fontsBold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '${resume.personalInfo?.email ?? ''} | ${resume.personalInfo?.phone ?? ''}',
          style: const pw.TextStyle(fontSize: 11),
        ),
        if ((resume.socials).isNotEmpty)
          ...(resume.socials).map(
            (e) => pw.Text(
              '${e.platform ?? ''}: ${e.url ?? ''}',
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
        font: fontsBold,
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
            e.position ?? '',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              font: fontsBold,
            ),
          ),
          pw.Text(
            '${e.company ?? ''} • ${e.startDate ?? ''}-${e.endDate ?? ''}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          if ((e.description ?? '').isNotEmpty)
            pw.Text(
              e.description ?? '',
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
        '${e.degree ?? ''}, ${e.school ?? ''} (${e.startDate ?? ''}-${e.endDate ?? ''})',
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  pw.Widget _buildLanguageItem(Language l) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Text(
        '${l.language ?? ''}: ${l.proficiencyLevel ?? ''}',
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
                s.name ?? '',
                style: const pw.TextStyle(fontSize: 10),
              ),
            );
          }).toList(),
    );
  }

  @override
  String displayName(AppLocalizations translated) =>
      translated.template_international;

  @override
  String get id => 'internacional';

  @override
  PlanType get minPlan => PlanType.premium;
}
