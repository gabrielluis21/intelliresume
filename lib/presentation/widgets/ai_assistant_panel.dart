import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/AI/ai_providers.dart';
import 'package:intelliresume/core/providers/AI/usage_provider.dart';
import 'package:intelliresume/core/providers/domain_providers.dart';
import 'package:intelliresume/core/providers/resume/cv_provider.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';

class AIAssistantPanel extends ConsumerStatefulWidget {
  const AIAssistantPanel({super.key});

  @override
  ConsumerState<AIAssistantPanel> createState() => _AIAssistantPanelState();
}

class _AIAssistantPanelState extends ConsumerState<AIAssistantPanel> {
  bool _isLoading = false;
  String? _resultText;
  String? _errorText;
  late AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
  }

  Future<void> _runAi(Future<String> Function(String) getResult) async {
    // --- NOVA LÓGICA DESACOPLADA ---
    final canUseAI = ref.read(canUseAIUseCaseProvider);
    final userId = ref.read(userProfileProvider).value?.uid;
    final currentInteractions = ref.read(usageTrackerProvider).aiInteractions;

    if (userId == null) {
      // Se não houver usuário, não faz nada.
      // Idealmente, o painel nem estaria visível.
      return;
    }

    final bool podeUsar = await canUseAI(
      userId: userId,
      currentAiInteractions: currentInteractions,
    );

    if (!podeUsar) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.aiAssistant_freePlanLimitReached),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    // --- FIM DA NOVA LÓGICA ---

    // OBTÉM OS DADOS DO CURRÍCULO E DO USUÁRIO
    final currentUserProfile = ref.read(userProfileProvider).value;
    final currentResumeData = ref.read(localResumeProvider);

    // COMBINA OS DADOS DO USUÁRIO COM OS DADOS DO CURRÍCULO ANTES DE ENVIAR PARA A IA
    final fullResumeData = currentResumeData.copyWith(
      personalInfo: currentUserProfile,
    );

    final resumeContent = fullResumeData.toFormattedString();

    if (resumeContent.trim().isEmpty) {
      setState(() {
        _errorText = l10n.aiAssistant_emptyResumeWarning;
        _resultText = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _resultText = null;
      _errorText = null;
    });

    try {
      final prompt = l10n.aiAssistant_recruitmentExpertPrompt(resumeContent);
      final result = await getResult(prompt);

      // Registra o uso da IA (lógica de UI)
      ref.read(usageTrackerProvider.notifier).incrementAI();

      setState(() {
        _resultText = result;
      });
    } catch (e) {
      setState(() {
        _errorText = l10n.aiAssistant_errorContactingAI(e.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiService = ref.watch(aiServiceProvider);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    text: l10n.aiAssistant_translate,
                    onPressed:
                        _isLoading
                            ? null
                            // TODO: Allow user to select language
                            : () => _runAi((p) => aiService.translate(p, 'en')),
                    backgroundColor: const Color(0xFFD7F9E9), // Light green
                    foregroundColor: Colors.black,
                  ),
                  _buildActionButton(
                    text: l10n.aiAssistant_strengthsAndWeaknesses,
                    onPressed:
                        _isLoading ? null : () => _runAi(aiService.evaluate),
                    backgroundColor: const Color(0xFFD6EAF8), // Light blue
                    foregroundColor: Colors.black,
                  ),
                  _buildActionButton(
                    text: l10n.aiAssistant_spellCheck,
                    onPressed:
                        _isLoading ? null : () => _runAi(aiService.correct),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    isOutlined: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // ResultCard
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildResultContent(),
              ),
              const SizedBox(height: 16),
              // Bottom buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement resume generation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF303F9F), // Dark blue
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(l10n.aiAssistant_generateResume),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Implement expand panel
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(l10n.aiAssistant_expand),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color foregroundColor,
    bool isOutlined = false,
  }) {
    return Flexible(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: isOutlined ? const BorderSide(color: Colors.black) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          elevation: isOutlined ? 0 : null,
        ),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildResultContent() {
    // OBTÉM OS DADOS DO CURRÍCULO E DO USUÁRIO
    final currentUserProfile = ref.watch(userProfileProvider).value;
    final currentResumeData = ref.watch(localResumeProvider);

    // COMBINA OS DADOS DO USUÁRIO COM OS DADOS DO CURRÍCULO ANTES DE EXIBIR
    final fullResumeData = currentResumeData.copyWith(
      personalInfo: currentUserProfile,
    );

    final resumeContent = fullResumeData.toFormattedString();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorText != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorText!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    // If there's a result from the AI, show it.
    if (_resultText != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(_resultText!),
      );
    }
    // Otherwise, show the original resume content.
    if (resumeContent.trim().isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.aiAssistant_emptyResumePlaceholder,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SelectableText(resumeContent),
    );
  }
}
