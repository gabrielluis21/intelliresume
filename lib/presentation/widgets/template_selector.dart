// --- Template Selector ---
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/templates/resume_template.dart';

import '../../core/providers/resume_template_provider.dart';

class TemplateSelector extends ConsumerWidget {
  const TemplateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templateListProvider);
    final selected = ref.watch(selectedTemplateProvider);

    return DropdownButton<Template>(
      value: selected,
      items:
          templates
              .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
              .toList(),
      onChanged: (value) {
        if (value != null) {
          ref.read(selectedTemplateProvider.notifier).state = value;
        }
      },
    );
  }
}
