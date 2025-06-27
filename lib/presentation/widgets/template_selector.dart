import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/busines_logic_intelliresume.dart';
import 'package:intelliresume/core/providers/resume_template_provider.dart';

class TemplateSelector extends ConsumerWidget {
  const TemplateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtém o serviço de lógica de negócio
    final logic = ref.watch(businessLogicServiceProvider);
    // Todos os templates disponíveis na plataforma
    final allTemplates = ref.watch(availableTemplatesProvider);

    // Filtra templates conforme plano do usuário (Free x Premium)
    final filteredTemplates =
        allTemplates.where((t) => logic.canUseTemplate(t.id)).toList();

    // Índice atualmente selecionado
    final selectedIndex = ref.watch(selectedTemplateIndexProvider);

    // Garante que o índice seja válido após alterações (ex: upgrade de plano)
    final safeIndex =
        selectedIndex < filteredTemplates.length ? selectedIndex : 0;

    return DropdownButton<int>(
      value: safeIndex,
      items: [
        for (var i = 0; i < filteredTemplates.length; i++)
          DropdownMenuItem(
            value: i,
            child: Text(filteredTemplates[i].displayName),
          ),
      ],
      onChanged: (idx) {
        if (idx != null) {
          ref.read(selectedTemplateIndexProvider.notifier).state = idx;
        }
      },
      hint: const Text('Selecione um template'),
      isExpanded: true,
    );
  }
}
