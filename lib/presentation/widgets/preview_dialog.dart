import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/presentation/widgets/export_buttons.dart';
import 'package:intelliresume/presentation/widgets/preview/resume_preview.dart';

class PreviewDialog extends ConsumerWidget {
  final ResumeData resume;

  const PreviewDialog({super.key, required this.resume});

  Widget _buildEmpytResume(BuildContext context) {
    return AlertDialog.adaptive(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Preview/Imprmir"),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
      content: Text("Preencha o CV antes de imprimir/pré visualizar"),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return resume.isEmpty
        ? _buildEmpytResume(context)
        : AlertDialog.adaptive(
          contentPadding: EdgeInsets.all(4),
          actionsPadding: EdgeInsets.all(15),
          scrollable: true,
          content: SizedBox(
            height: MediaQuery.of(context).size.height * .90,
            width: MediaQuery.of(context).size.width * .80,
            child: ResumePreview(),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Preview/Imprmir"),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
          actions: [ExportButtons(resumeData: resume)],
        );
  }
}
