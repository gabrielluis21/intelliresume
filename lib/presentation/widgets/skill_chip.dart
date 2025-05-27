import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String label;
  final ThemeData theme;
  const SkillChip({super.key, required this.label, required this.theme});

  @override
  Widget build(BuildContext c) =>
      Chip(label: Text(label, style: theme.textTheme.bodyLarge));
}
