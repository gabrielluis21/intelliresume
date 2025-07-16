import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/busines_logic_intelliresume.dart';
import 'package:intelliresume/core/providers/resume_template_provider.dart';
import 'package:intelliresume/core/templates/resume_template.dart';

class TemplateSelector extends ConsumerWidget {
  const TemplateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtém o serviço de lógica de negócio
    final logic = ref.watch(businessLogicServiceProvider);
    // Todos os templates disponíveis na plataforma
    final allTemplates = ResumeTemplate.allTemplates;
    // Filtra templates conforme plano do usuário (Free x Premium)
    final filteredTemplates =
        allTemplates.where((t) => logic.canUseTemplate(t.id)).toList();
    final selected = ref.watch(selectedTemplateProvider);

    return SizedBox(
      width: 220,
      child: DropdownButton<ResumeTemplate>(
        value: selected,
        items:
            filteredTemplates
                .map(
                  (element) => DropdownMenuItem(
                    value: element,
                    child: Text(element.displayName),
                  ),
                )
                .toList(),
        onChanged: (idx) {
          if (idx != null) {
            print(idx);
            ref.read(selectedTemplateProvider.notifier).state = idx;
          }
        },
        hint: const Text('Selecione um template'),
        isExpanded: true,
      ),
    );
  }
}
