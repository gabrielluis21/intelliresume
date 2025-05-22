import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String label;
  const SkillChip({super.key, required this.label});
  @override
  Widget build(BuildContext c) => Chip(label: Text(label));
}
