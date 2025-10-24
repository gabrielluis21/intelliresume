import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? textColor;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultColor =
        textColor ?? Theme.of(context).colorScheme.onSurface;

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: defaultColor,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: defaultColor.withOpacity(0.7),
            ),
          ),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}
