import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  const HeaderSection({super.key, required this.title});

  @override
  Widget build(BuildContext c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(
          c,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
