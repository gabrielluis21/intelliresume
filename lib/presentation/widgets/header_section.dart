import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final ThemeData theme;
  const HeaderSection({super.key, required this.title, required this.theme});

  @override
  Widget build(BuildContext c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: theme.textTheme.headlineLarge),
    );
  }
}
