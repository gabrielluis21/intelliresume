import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeConsumeWidget<T> extends ConsumerWidget {
  final Widget Function(BuildContext context, WidgetRef ref) builder;

  const ThemeConsumeWidget({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return builder(context, ref);
  }
}
