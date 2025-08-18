import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/ai_providers.dart';
import 'package:intelliresume/core/providers/cv_provider.dart';

class AIAssistantPanel extends ConsumerStatefulWidget {
  const AIAssistantPanel({super.key});

  @override
  ConsumerState<AIAssistantPanel> createState() => _AIAssistantPanelState();
}

class _AIAssistantPanelState extends ConsumerState<AIAssistantPanel> {
  bool _isLoading = false;
  String? _resultText;
  String? _errorText;

  // Função genérica para lidar com as chamadas de IA
  Future<void> _handleAIAssistantAction(
    Future<String> Function(String) aiAction,
  ) async {
    setState(() {
      _isLoading = true;
      _resultText = null;
      _errorText = null;
    });

    try {
      // Concatena os dados do currículo em um único texto para análise
      final resumeData = ref.read(localResumeProvider);
      final fullResumeText =
          resumeData
              .toMap()
              .toString(); // Uma forma simples de obter todo o texto

      final result = await aiAction(fullResumeText);
      setState(() {
        _resultText = result;
      });
    } catch (e) {
      setState(() {
        _errorText = "Ocorreu um erro ao contatar a IA: \$e";
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
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Avaliar'),
                onPressed:
                    _isLoading
                        ? null
                        : () => _handleAIAssistantAction(aiService.evaluate),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.spellcheck),
                label: const Text('Corrigir'),
                onPressed:
                    _isLoading
                        ? null
                        : () => _handleAIAssistantAction(aiService.correct),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.translate),
                label: const Text('Traduzir'),
                onPressed:
                    _isLoading
                        ? null
                        : () {
                          // A lógica de tradução pode precisar de um input de idioma
                          // Por enquanto, vamos usar um placeholder
                          _handleAIAssistantAction(
                            (text) => aiService.translate(text, 'English'),
                          );
                        },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : (_resultText == null && _errorText == null)
                      ? const Center(
                        child: Text('Os resultados da IA aparecerão aqui.'),
                      )
                      : SelectableText(
                        _resultText ?? _errorText ?? '',
                        style: TextStyle(
                          color: _errorText != null ? Colors.red : null,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
