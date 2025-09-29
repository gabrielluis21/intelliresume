import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/AI/ai_providers.dart';
import 'package:intelliresume/core/providers/resume/cv_provider.dart';
import 'package:intelliresume/data/models/cv_data.dart';

class AIAssistantPanel extends ConsumerWidget {
  const AIAssistantPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumeData = ref.watch(localResumeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Assistente de IA',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Selecione uma seção para analisar e otimizar seu conteúdo.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildSectionPanel(
            context: context,
            ref: ref,
            title: 'Currículo Completo',
            content: resumeData.toFormattedString(),
            onApply: (suggestion) {
              // A lógica para aplicar ao currículo inteiro é mais complexa
              // e pode ser implementada no futuro.
            },
          ),
          if (resumeData.objective != null && resumeData.objective!.isNotEmpty)
            _buildSectionPanel(
              context: context,
              ref: ref,
              title: 'Objetivo',
              content: resumeData.objective!,
              onApply: (suggestion) {
                ref
                    .read(localResumeProvider.notifier)
                    .updateObjective(suggestion);
              },
            ),
          ..._buildExperiencePanels(context, ref, resumeData.experiences ?? []),
        ],
      ),
    );
  }

  List<Widget> _buildExperiencePanels(
    BuildContext context,
    WidgetRef ref,
    List<Experience> experiences,
  ) {
    return experiences.asMap().entries.map((entry) {
      final index = entry.key;
      final exp = entry.value;
      final title = 'Experiência: ${exp.position ?? 'N/A'}';
      final content = '''
        Cargo: ${exp.position}
        Empresa: ${exp.company}
        Período: ${exp.startDate} - ${exp.endDate}
        Descrição: ${exp.description}
      ''';

      return _buildSectionPanel(
        context: context,
        ref: ref,
        title: title,
        content: content,
        onApply: (suggestion) {
          // Aqui, idealmente, a IA retornaria apenas a descrição corrigida.
          // A lógica de "diff" e aplicação parcial seria mais robusta.
          final newExperience = exp.copyWith(description: suggestion);
          ref
              .read(localResumeProvider.notifier)
              .updateExperience(index, newExperience);
        },
      );
    }).toList();
  }

  Widget _buildSectionPanel({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String content,
    required ValueChanged<String> onApply,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(title),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AIResultWidget(contentToAnalyze: content, onApply: onApply),
          ),
        ],
      ),
    );
  }
}

// Widget interno para gerenciar o estado de cada chamada de IA
class AIResultWidget extends ConsumerStatefulWidget {
  final String contentToAnalyze;
  final ValueChanged<String> onApply;

  const AIResultWidget({
    super.key,
    required this.contentToAnalyze,
    required this.onApply,
  });

  @override
  ConsumerState<AIResultWidget> createState() => _AIResultWidgetState();
}

class _AIResultWidgetState extends ConsumerState<AIResultWidget> {
  bool _isLoading = false;
  String? _resultText;
  String? _errorText;

  Future<void> _handleAIAction(Future<String> Function(String) aiAction) async {
    if (widget.contentToAnalyze.trim().isEmpty) {
      setState(() {
        _errorText = "Não há conteúdo para analisar.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _resultText = null;
      _errorText = null;
    });

    try {
      // O prompt pode ser melhorado para dar mais contexto à IA
      final prompt =
          'Você é um especialista em recrutamento. Revise e corrija o seguinte texto para um currículo, melhorando o impacto e a clareza:\n\n${widget.contentToAnalyze}';
      final result = await aiAction(prompt);
      setState(() {
        _resultText = result;
      });
    } catch (e) {
      setState(() {
        _errorText = "Ocorreu um erro ao contatar a IA: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiService = ref.watch(aiServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.spellcheck),
              label: const Text('Corrigir e Otimizar'),
              onPressed:
                  _isLoading ? null : () => _handleAIAction(aiService.correct),
            ),
            // Outros botões como "Traduzir" podem ser adicionados aqui
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_resultText != null)
          _buildResultCard(
            original: widget.contentToAnalyze,
            suggestion: _resultText!,
            onApply: () {
              widget.onApply(_resultText!);
              setState(() {
                _resultText = null; // Limpa o resultado após aplicar
              });
            },
          )
        else
          Center(
            child: Text(
              _errorText ?? 'Clique em um botão para iniciar a análise.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _errorText != null ? Colors.red : null),
            ),
          ),
      ],
    );
  }

  Widget _buildResultCard({
    required String original,
    required String suggestion,
    required VoidCallback onApply,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sugestão da IA:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectableText(suggestion),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Aplicar Sugestão'),
                onPressed: onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
