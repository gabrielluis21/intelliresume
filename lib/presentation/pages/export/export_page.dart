import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/domain_providers.dart';
import 'package:intelliresume/core/templates/resume_template.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    switch (templateId) {
      case 'intelliresume_pattern':
        return l10n.exportPage_defaultTemplateDescription;
      case 'classic':
        return l10n.exportPage_classicTemplateDescription;
      case 'studant_first_job':
        return l10n.exportPage_studentFirstJobTemplateDescription;
      case 'modern_side':
        return l10n.exportPage_modernSideTemplateDescription;
      case 'internacional':
        return l10n.exportPage_internationalTemplateDescription;
      case 'dev_tec':
        return l10n.exportPage_devTecTemplateDescription;
      default:
        return l10n.exportPage_professionalTemplateDescription;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTemplate = ref.watch(selectedTemplateProvider);
    final l10n = AppLocalizations.of(context)!;
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
              l10n.exportPage_chooseTemplate,
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
              l10n.exportPage_customizeOptional,
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
        label: Text(l10n.exportPage_generateAndPreviewPDF),
        icon: const Icon(Icons.picture_as_pdf_outlined),
        tooltip: l10n.exportPage_generateAndPreviewPDFTooltip,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _generatePdf(
    BuildContext context,
    WidgetRef ref,
    ResumeTemplate template,
  ) async {
    final l10n = AppLocalizations.of(context)!;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.exportPage_errorGeneratingPDF(e.toString() as Object),
          ),
        ),
      );
    }
  }

  void _showUpgradeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.exportPage_premiumTemplate),
            content: Text(l10n.exportPage_premiumTemplateMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.exportPage_close),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('/buy');
                },
                child: Text(l10n.exportPage_viewPlans),
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
    final l10n = AppLocalizations.of(context)!;

    return canUseAsync.when(
      loading:
          () => const Card(child: Center(child: CircularProgressIndicator())),
      error:
          (e, s) => Card(
            child: Center(child: Text(l10n.exportPage_error(e.toString()))),
          ),
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
                          template.displayName(l10n),
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(description, style: textTheme.bodySmall),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(
                            canUse
                                ? l10n.exportPage_free
                                : l10n.exportPage_premium,
                          ),
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
    final l10n = AppLocalizations.of(context)!;
    final supportedLanguages = {
      'en': l10n.exportPage_english,
      'es': l10n.exportPage_spanish,
      'fr': l10n.exportPage_french,
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
              hint: Text(l10n.exportPage_selectLanguage),
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
                labelText: l10n.exportPage_translateResume,
                helperText:
                    isInternational
                        ? l10n.exportPage_contentWillBeTranslated
                        : l10n.exportPage_availableOnlyInternational,
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
