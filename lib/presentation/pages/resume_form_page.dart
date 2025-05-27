// Melhorias aplicadas:
// - Separação de responsabilidades (SOLID)
// - Extração de widgets para limpeza de código
// - Validações mais robustas
// - Melhor UX para mobile e PWA (scroll suave, botões fixos, feedback claro)
// - Internationalization support mantido
// - Padding e espaçamento consistente para acessibilidade

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/presentation/widgets/resume_preview.dart';
import '../../core/providers/resume_template_provider.dart';
import '../../core/utils/app_localizations.dart';
import '../widgets/resume_form.dart';

class ResumeFormPage extends ConsumerWidget {
  const ResumeFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isWide) {
            return Row(
              children: [
                Expanded(child: ResumeFormContent()),
                const VerticalDivider(),
                Expanded(child: ResumePreview()),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ResumeFormContent(),
                  const Divider(),
                  ResumePreview(),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTemplateDialog(context, ref),
        icon: Icon(Icons.palette),
        label: Text('Select Theme'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _showTemplateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolha um modelo de currículo'),
          content: SingleChildScrollView(
            child: Column(
              children:
                  resumeTemplates.map((template) {
                    return ListTile(
                      title: Text(template.name),
                      subtitle: Text(
                        'Fonte: ${template.fontFamily}, Colunas: ${template.columns}',
                      ),
                      onTap: () {
                        ref.read(selectedTemplateProvider.notifier).state =
                            template;
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
