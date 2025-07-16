// utils/document_builder.dart
//import 'package:intelliresume/core/templates/resume_template.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../data/models/cv_data.dart';

class DocumentBuilder {
  final dynamic template;
  DocumentBuilder(this.template);

  pw.Document generate(ResumeData data, context) {
    print(template.id);
    template.loadFonts();
    final pdf = template.buildPdf(data, context);
    return pdf;
  }
}
