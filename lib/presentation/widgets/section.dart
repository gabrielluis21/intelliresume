import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final Widget child;
  final TextTheme titleStyle;

  const Section({
    super.key,
    required this.title,
    required this.titleStyle,
    required this.child,
  });

  @override
  Widget build(BuildContext c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle.titleMedium),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
