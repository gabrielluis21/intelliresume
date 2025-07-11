import 'package:flutter/material.dart';

import '../../../../data/models/cv_data.dart';

class SkillChip extends StatelessWidget {
  final List<Skill> skills;
  final TextTheme? theme;
  const SkillChip({super.key, required this.skills, this.theme});

  @override
  Widget build(BuildContext c) {
    if (skills.isEmpty) return Text('Nenhuma habilidade adicionada');
    return ListView.builder(
      itemCount: skills.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, indx) {
        return Chip(
          label: Text("${skills[indx].name} - ${skills[indx].level}"),
          labelStyle: theme?.bodyMedium?.copyWith(color: Colors.blue.shade800),
        );
      },
    );
  }
}
