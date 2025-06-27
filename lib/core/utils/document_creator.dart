// utils/document_builder.dart
import 'package:intelliresume/core/templates/resume_template.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../data/models/cv_data.dart';

class DocumentBuilder {
  final ResumeTemplate template;
  DocumentBuilder(this.template);

  pw.Document generate(ResumeData data, context) {
    final pdf = template.buildPdf(data, context);
    return pdf;
  }
}

/* static pw.Document buildPDF(
    BuildContext context,
    ResumeData resumeData, {
    ResumeStyle style = ResumeStyle.style0,
  }) {
    switch (style) {
      case ResumeStyle.style1:
        return StyledResume.generateStyle1(resumeData);
      case ResumeStyle.style2:
        return StyledResume.generateStyle2(resumeData);
      case ResumeStyle.style3:
        return StyledResume.generateStyle3(resumeData);
      case ResumeStyle.style4:
        return StyledResume.generateStyle4(resumeData);
      case ResumeStyle.style5:
        return StyledResume.generateStyle5(resumeData);
      case ResumeStyle.style6:
        return StyledResume.generateStyle6(resumeData);
      case ResumeStyle.style7:
        return StyledResume.generateStyle7(resumeData);
      case ResumeStyle.style8:
        return StyledResume.generateStyle8(resumeData);
      case ResumeStyle.style9:
        return StyledResume.generateStyle9(resumeData);
      case ResumeStyle.style10:
        return StyledResume.generateStyle10(resumeData);
      default:
        return StyledResume.generateStyle0(resumeData, context);
    }
  }
} */
