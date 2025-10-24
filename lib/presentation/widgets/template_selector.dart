import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/resume/resume_template_provider.dart';
import 'package:intelliresume/core/templates/resume_template.dart';
import 'package:intelliresume/generated/app_localizations.dart';

class TemplateSelector extends ConsumerWidget {
  const TemplateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Observa o FutureProvider que prepara a lista de templates
    final availableTemplatesAsync = ref.watch(availableTemplatesProvider);
    final translated = AppLocalizations.of(context)!;

    // 2. Usa o .when para lidar com os estados de carregamento, erro e sucesso
    return availableTemplatesAsync.when(
      loading:
          () => const SizedBox(
            width: 220,
            child: Center(child: CircularProgressIndicator()),
          ),
      error:
          (err, stack) => SizedBox(
            width: 220,
            child: Text(translated.templateSelector_errorLoadingTemplates),
          ),
      data: (filteredTemplates) {
        // Uma vez que os dados carregam, garantimos que um template inicial seja selecionado.
        final selected = ref.watch(selectedTemplateProvider);
        if (selected == null && filteredTemplates.isNotEmpty) {
          Future.microtask(() {
            ref.read(selectedTemplateProvider.notifier).state =
                filteredTemplates.first;
          });
        }

        return SizedBox(
          width: 220,
          child: DropdownButton<ResumeTemplate>(
            value: selected,
            items:
                filteredTemplates
                    .map(
                      (element) => DropdownMenuItem(
                        value: element,
                        child: Text(element.displayName(translated)),
                      ),
                    )
                    .toList(),
            onChanged: (template) {
              if (template != null) {
                ref.read(selectedTemplateProvider.notifier).state = template;
              }
            },
            hint: Text(translated.templateSelector_selectTemplate),
            isExpanded: true,
          ),
        );
      },
    );
  }
}
