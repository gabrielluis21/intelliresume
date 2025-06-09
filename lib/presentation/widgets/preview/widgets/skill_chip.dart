import 'package:flutter/material.dart';

import '../../../../data/models/cv_data.dart';

class SkillChip extends StatelessWidget {
  final Skill skill;
  final TextTheme? theme;
  const SkillChip({super.key, required this.skill, this.theme});

  @override
  Widget build(BuildContext c) => Chip(
    label: Text("${skill.name} - ${skill.level}"),
    labelStyle: theme?.bodyMedium?.copyWith(color: Colors.blue.shade800),
  );
}
