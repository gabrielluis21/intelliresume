import 'package:flutter/material.dart';

class ResumeTemplate {
  final String name;
  final ThemeData theme;
  final int columns;
  final String fontFamily;

  ResumeTemplate({
    required this.name,
    required this.theme,
    required this.columns,
    required this.fontFamily,
  });

  factory ResumeTemplate.fromJson(Map<String, dynamic> json) {
    return ResumeTemplate(
      name: json['name'] as String,
      theme: ThemeData(
        primaryColor: Color(json['theme']['primaryColor'] ?? 0xFF2196F3),
        hintColor: Color(json['theme']['hintColor'] ?? 0xFFFFC107),
      ),
      columns: json['columns'] as int,
      fontFamily: json['fontFamily'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'theme': {
        'primaryColor': theme.primaryColor,
        'hintColor': theme.hintColor,
      },
      'columns': columns,
      'fontFamily': fontFamily,
    };
  }
}
