import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/domain_providers.dart';
import 'package:intelliresume/core/templates/resume_template.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/presentation/pages/export/export_pdf_page.dart';

// O provider agora armazena a instância completa do template
final selectedTemplateProvider = StateProvider<ResumeTemplate>((ref) {
  return ResumeTemplate.allTemplates.first;
});

final targetLanguageProvider = StateProvider<String?>((ref) => null);

class ExportPage extends ConsumerWidget {
  final ResumeData? resumeData;

  const ExportPage({super.key, required this.resumeData});

  String _getTemplateDescription(String templateId, BuildContext context) {
    switch (templateId) {
      case 'intelliresume_pattern':
        return 'Nosso modelo padrão, balanceado e profissional.';
      case 'classic':
        return 'Um design limpo e clássico, focado no conteúdo.';
      case 'studant_first_job':
        return 'Ideal para estudantes e primeiro emprego.';
      case 'modern_side':
        return 'Um layout moderno com uma barra lateral elegante.';
      case 'internacional':
        return 'Formato universal, pronto para tradução.';
      case 'dev_tec':
        return 'Feito para desenvolvedores, destacando skills e projetos.';
      default:
        return 'Um modelo profissional para o seu currículo.';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTemplate = ref.watch(selectedTemplateProvider);
    // A LÓGICA DE NEGÓCIO FOI REMOVIDA DAQUI
    final allTemplates = ResumeTemplate.allTemplates;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Escolha o Modelo',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // O map agora apenas renderiza os cards, sem lógica de permissão
            ...allTemplates.map((template) {
              final isSelected = template.id == selectedTemplate.id;
              return _TemplateSelectionCard(
                template: template,
                description: _getTemplateDescription(template.id, context),
                isSelected: isSelected,
                // O onTap agora é tratado dentro do card, que conhece a permissão
                onSelected: () {
                  ref.read(selectedTemplateProvider.notifier).state = template;
                },
                onRequiresUpgrade: () => _showUpgradeDialog(context),
              );
            }),
            const SizedBox(height: 24),
            Text(
              '2. Personalize (Opcional)',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _ExportOptionsCard(selectedTemplate: selectedTemplate),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _generatePdf(context, ref, selectedTemplate),
        label: const Text('Gerar e Visualizar PDF'),
        icon: const Icon(Icons.picture_as_pdf_outlined),
        tooltip: 'Gerar e visualizar o currículo em formato PDF',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _generatePdf(
    BuildContext context,
    WidgetRef ref,
    ResumeTemplate template,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final language = ref.read(targetLanguageProvider);
      final pdfDoc = await template.buildPdf(
        resumeData!,
        context,
        targetLanguage: language,
      );
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PreviewPdfScreen(pdf: pdfDoc)),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao gerar PDF: $e')));
    }
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Template Premium'),
            content: const Text(
              'Este template está disponível apenas nos planos Premium ou Pro. Faça o upgrade para usareste e muitos outros recursos!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('/buy');
                },
                child: const Text('Ver Planos'),
              ),
            ],
          ),
    );
  }
}

// O CARD AGORA É UM CONSUMERWIDGET
class _TemplateSelectionCard extends ConsumerWidget {
  final ResumeTemplate template;
  final String description;
  final bool isSelected;
  final VoidCallback onSelected;
  final VoidCallback onRequiresUpgrade;

  const _TemplateSelectionCard({
    required this.template,
    required this.description,
    required this.isSelected,
    required this.onSelected,
    required this.onRequiresUpgrade,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // CADA CARD AGORA OBSERVA SEU PRÓPRIO ESTADO DE PERMISSÃO
    final canUseAsync = ref.watch(canUseTemplateProviderFamily(template.id));
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final mockImagePath = 'images/cv/cv_${template.id}_mock.png';

    return canUseAsync.when(
      loading:
          () => const Card(child: Center(child: CircularProgressIndicator())),
      error: (e, s) => Card(child: Center(child: Text('Erro: $e'))),
      data: (canUse) {
        return Card(
          elevation: isSelected ? 4.0 : 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color:
                  isSelected
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: canUse ? onSelected : onRequiresUpgrade,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Radio<String>(
                    value: template.id,
                    groupValue: isSelected ? template.id : '',
                    onChanged:
                        (value) => canUse ? onSelected() : onRequiresUpgrade(),
                    activeColor: colorScheme.primary,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.displayName,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(description, style: textTheme.bodySmall),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(canUse ? 'Grátis' : 'Premium'),
                          avatar:
                              canUse
                                  ? null
                                  : Icon(
                                    Icons.workspace_premium,
                                    size: 16,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                          backgroundColor:
                              canUse
                                  ? colorScheme.secondaryContainer.withOpacity(
                                    0.5,
                                  )
                                  : colorScheme.secondaryContainer,
                          side: BorderSide.none,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 70,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        mockImagePath,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: colorScheme.surfaceVariant,
                              child: const Center(
                                child: Icon(Icons.article_outlined),
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Card de Opções de Exportação (sem alterações)
class _ExportOptionsCard extends ConsumerWidget {
  final ResumeTemplate selectedTemplate;
  const _ExportOptionsCard({required this.selectedTemplate});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInternational = selectedTemplate.id == 'international';
    final selectedLanguage = ref.watch(targetLanguageProvider);
    final supportedLanguages = {
      'en': 'Inglês (English)',
      'es': 'Espanhol (Español)',
      'fr': 'Francês (Français)',
    };
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              hint: const Text('Selecione um idioma...'),
              onChanged:
                  isInternational
                      ? (String? newValue) {
                        ref.read(targetLanguageProvider.notifier).state =
                            newValue;
                      }
                      : null,
              items:
                  supportedLanguages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
              decoration: InputDecoration(
                labelText: 'Traduzir currículo',
                helperText:
                    isInternational
                        ? 'O conteúdo será traduzido.'
                        : 'Disponível apenas para o modelo Internacional.',
                border: const OutlineInputBorder(),
                filled: !isInternational,
                fillColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
