// lib/presentation/pages/export/export_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/busines_logic_intelliresume.dart';
import 'package:intelliresume/core/templates/resume_template.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/presentation/pages/export/export_pdf_page.dart';
import 'package:go_router/go_router.dart';

// O provider agora armazena a instância completa do template
final selectedTemplateProvider = StateProvider<ResumeTemplate>((ref) {
  return ResumeTemplate.allTemplates.first;
});

final targetLanguageProvider = StateProvider<String?>((ref) => null);

class ExportPage extends ConsumerWidget {
  final ResumeData? resumeData;

  const ExportPage({super.key, required this.resumeData});

  // Helper para fornecer descrições amigáveis para cada template
  String _getTemplateDescription(String templateId, BuildContext context) {
    // Você pode usar AppLocalizations aqui se as descrições forem traduzidas
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
    final logic = ref.watch(businessLogicServiceProvider);
    final allTemplates = ResumeTemplate.allTemplates;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Espaço para o FAB
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Seção de Seleção de Template
            Text(
              '1. Escolha o Modelo',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...allTemplates.map((template) {
              final canUse = logic.canUseTemplate(template.id);
              final isSelected = template.id == selectedTemplate.id;

              return Semantics(
                // A label descreve o card inteiro para o leitor de tela
                label:
                    'Modelo: ${template.displayName}. '
                    '${_getTemplateDescription(template.id, context)}. '
                    '${canUse ? "Plano Grátis." : "Requer plano Premium."} '
                    '${isSelected ? "Atualmente selecionado." : ""}',
                selected: isSelected,
                button: true,
                child: _TemplateSelectionCard(
                  template: template,
                  description: _getTemplateDescription(template.id, context),
                  canUse: canUse,
                  isSelected: isSelected,
                  onTap: () {
                    if (canUse) {
                      ref.read(selectedTemplateProvider.notifier).state =
                          template;
                    } else {
                      _showUpgradeDialog(context);
                    }
                  },
                ),
              );
            }),

            const SizedBox(height: 24),

            // 2. Seção de Opções
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
        // Tooltip é lido por leitores de tela para descrever a ação do botão
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

      print(resumeData?.personalInfo?.toJson());
      final pdfDoc = await template.buildPdf(
        resumeData!,
        context,
        targetLanguage: language,
      );

      Navigator.of(context).pop(); // Fecha o loading
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PreviewPdfScreen(pdf: pdfDoc)),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Fecha o loading em caso de erro
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
              'Este template está disponível apenas nos planos Premium ou Pro. Faça o upgrade para usar este e muitos outros recursos!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                  context.push('/buy'); // Navega para a página de planos
                },
                child: const Text('Ver Planos'),
              ),
            ],
          ),
    );
  }
}

// Card de Seleção de Template
class _TemplateSelectionCard extends StatelessWidget {
  final ResumeTemplate template;
  final String description;
  final bool canUse;
  final bool isSelected;
  final VoidCallback onTap;

  const _TemplateSelectionCard({
    required this.template,
    required this.description,
    required this.canUse,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final mockImagePath = 'images/cv/cv_${template.id}_mock.png';

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
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Radio button para seleção clara e acessível
              Radio<String>(
                value: template.id,
                groupValue: isSelected ? template.id : '',
                onChanged: (value) => onTap(),
                activeColor: colorScheme.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(template.displayName, style: textTheme.titleMedium),
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
                              ? colorScheme.secondaryContainer.withOpacity(0.5)
                              : colorScheme.secondaryContainer,
                      side: BorderSide.none,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Miniatura com tratamento para erro de imagem
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
  }
}

// Card de Opções de Exportação
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
            // Dropdown de idioma sempre visível, mas desabilitado quando não aplicável
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              hint: const Text('Selecione um idioma...'),
              // Desabilita o dropdown se o template não for o internacional
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
                // Mensagem de ajuda que explica por que está desabilitado
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
