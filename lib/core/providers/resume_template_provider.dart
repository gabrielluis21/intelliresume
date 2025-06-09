import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/cv_provider.dart';
import '../../data/models/cv_data.dart';
import '../../data/models/resume_template.dart';
import '../../services/export/export_services.dart'; // Nova importação

// Provedor para a lista de templates
final resumeTemplatesProvider = Provider<List<ResumeTemplate>>((ref) {
  return [
    ResumeTemplate(
      name: 'Clássico',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.blue),
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 14)),
      ),
      fontFamily: 'Noto Sans',
      columns: 1,
    ),
    ResumeTemplate(
      name: 'Moderno',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.blue),
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 14)),
      ),
      fontFamily: 'Roboto',
      columns: 2,
    ),
    ResumeTemplate(
      name: 'Elegante',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.teal),
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 15)),
      ),
      fontFamily: 'Times New Roman',
      columns: 2,
    ),
    // ... outros 8 templates
  ];
});

// Provedor para o template selecionado
final selectedTemplateProvider = StateProvider<ResumeTemplate>((ref) {
  return ref.watch(resumeTemplatesProvider)[0];
});

// Provedor para serviços de exportação (Novo)
final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});

// Provedor para controlar a visualização/exportação (Novo)
final resumeControllerProvider = ChangeNotifierProvider((ref) {
  return ResumeController(
    exportService: ref.watch(exportServiceProvider),
    template: ref.watch(selectedTemplateProvider),
    data: ref.watch(resumeProvider.notifier).state, // Obtém os dados do CV
  );
});

// Controlador para exportação (Novo)
class ResumeController extends ChangeNotifier {
  final ExportService _exportService;
  ResumeTemplate _template;
  ResumeData _data;

  ResumeTemplate get template => _template;

  ResumeController({
    required ExportService exportService,
    required ResumeTemplate template,
    required ResumeData data,
  }) : _exportService = exportService,
       _template = template,
       _data = data;

  /*
  Future<void> exportToPdf(BuildContext context) async {
    final result = await _exportService.exportToPdf(
      context: context,
      template: _template,
      resumeData: _data,
    );
    // Tratar resultado da exportação
  }

  Future<void> exportToDocx(BuildContext context) async {
    final result = await _exportService.exportToDocx(
      context: context,
      template: _template,
      resumeData: _data,
    );
    // Tratar resultado da exportação
  } */

  void updateTemplate(ResumeTemplate newTemplate) {
    _template = newTemplate;
    notifyListeners();
  }
}
