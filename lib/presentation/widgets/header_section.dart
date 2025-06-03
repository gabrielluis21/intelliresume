import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final TextTheme textTheme;
  const HeaderSection({
    super.key,
    required this.title,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}
