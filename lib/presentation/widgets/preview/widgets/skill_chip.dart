import 'package:flutter/material.dart';

import '../../../../data/models/cv_data.dart';

class SkillChip extends StatelessWidget {
  final Skill skills;
  final TextTheme? theme;
  const SkillChip({super.key, required this.skills, this.theme});

  @override
  Widget build(BuildContext c) {
    return Chip(
      label: Text("${skills.name} - ${skills.level}"),
      labelStyle: theme?.bodyMedium?.copyWith(color: Colors.blue.shade800),
    );
  }
}
