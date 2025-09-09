import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// A class to generate a PDF resume with a modern sidebar layout.
class ModernSidebarBuilder {
  /// Generates the PDF document from the provided [ResumeData].
  ///
  /// Returns a [Future<Uint8List>] containing the bytes of the generated PDF.
  Future<Uint8List> build(ResumeData resumeData) async {
    final pdf = pw.Document();

    // Load fonts from assets
    final font = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(font);

    final sidebarColor = PdfColor.fromHex('#2C2A63');
    final textColor = PdfColors.white;

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: ttf),
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Row(
            children: [
              // Left Sidebar
              _buildSidebar(resumeData, ttf, sidebarColor, textColor),
              // Right Main Content
              _buildMainContent(resumeData, ttf),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Builds the left sidebar widget.
  pw.Widget _buildSidebar(
    ResumeData resumeData,
    pw.Font ttf,
    PdfColor sidebarColor,
    PdfColor textColor,
  ) {
    final skills = resumeData.skills ?? [];

    return pw.Container(
      width: 210, // A4 width is 595, this is roughly 35%
      color: sidebarColor,
      padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            resumeData.personalInfo?.name?.toUpperCase() ?? 'YOUR NAME',
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
          _buildSidebarInfo(resumeData.personalInfo?.email, textColor),
          _buildSidebarInfo(resumeData.personalInfo?.phone, textColor),
          // The cv_data model does not have an address field in UserProfile.
          // Add it to your model or use a placeholder if needed.
          // _buildSidebarInfo('Your City, Country', textColor),
          pw.Spacer(),
          if (skills.isNotEmpty) ...[
            pw.Text(
              'Skills',
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
  pw.Widget _buildMainContent(ResumeData resumeData, pw.Font ttf) {
    return pw.Expanded(
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Profile Section
            if (resumeData.about != null && resumeData.about!.isNotEmpty) ...[
              _buildSectionTitle('Profile'),
              pw.Text(
                resumeData.about!,
                style: const pw.TextStyle(fontSize: 10.5, height: 1.6),
                textAlign: pw.TextAlign.justify,
              ),
              pw.SizedBox(height: 24),
            ],
            // Experience Section
            if (resumeData.experiences != null &&
                resumeData.experiences!.isNotEmpty) ...[
              _buildSectionTitle('Experience'),
              ...resumeData.experiences!.map(
                (exp) => _buildExperienceItem(
                  title: exp.position?.toUpperCase() ?? 'JOB TITLE',
                  subtitle:
                      '${exp.company ?? 'Company'} | ${exp.startDate ?? ''} - ${exp.endDate ?? 'Present'}',
                  description: exp.description,
                ),
              ),
            ],
            // Education Section
            if (resumeData.educations != null &&
                resumeData.educations!.isNotEmpty) ...[
              _buildSectionTitle('Education'),
              ...resumeData.educations!.map(
                (edu) => _buildExperienceItem(
                  title: edu.degree?.toUpperCase() ?? 'DEGREE / COURSE',
                  subtitle:
                      '${edu.school ?? 'Institution'} | ${edu.startDate ?? ''} - ${edu.endDate ?? ''}',
                  description: edu.description,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper to build a line of info in the sidebar.
  pw.Widget _buildSidebarInfo(String? text, PdfColor color) {
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
}
