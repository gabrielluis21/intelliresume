import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/resume_template.dart';

final resumeTemplates = [
  ResumeTemplate(
    name: 'Clássico',
    theme: ThemeData(colorScheme: ColorScheme.light(primary: Colors.blue)),
    fontFamily: 'Roboto',
    columns: 2,
    fontSize: 14,
  ),
  ResumeTemplate(
    name: 'Elegante',
    theme: ThemeData(colorScheme: ColorScheme.light(primary: Colors.teal)),
    fontFamily: 'Merriweather',
    columns: 2,
    fontSize: 15,
  ),
  // ... outros 8 templates com diferentes configurações
];

final selectedTemplateProvider = StateProvider<ResumeTemplate>((ref) {
  return resumeTemplates.first;
});

class ResumeTemplateProvider extends ChangeNotifier {
  ResumeTemplate _currentTemplate = resumeTemplates.first;

  ResumeTemplate get currentTemplate => _currentTemplate;

  ThemeData get currentTheme =>
      resumeTemplates
          .firstWhere((element) => element.name == _currentTemplate.name)
          .theme;

  void setTemplate(ResumeTemplate template) {
    _currentTemplate = template;
    notifyListeners();
  }
}
