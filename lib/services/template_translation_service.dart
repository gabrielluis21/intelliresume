import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:intelliresume/data/models/cv_data.dart';

/// Serviço dedicado para traduções internas de templates,
/// que não contam como interações de IA para o usuário.
abstract class TemplateTranslationService {
  /// Traduz os campos de texto de um [ResumeData] para um idioma alvo.
  Future<ResumeData> translateResumeData(
    ResumeData data,
    String targetLanguage,
  );
}

class OpenAITemplateTranslationService implements TemplateTranslationService {
  final OpenAI _openAI;

  // Este serviço deve ser inicializado com uma chave de API "interna"
  // que não está associada ao plano do usuário.
  OpenAITemplateTranslationService({required String apiKey})
    : _openAI = OpenAI.instance.build(
        token: apiKey,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
        enableLog: true,
      );

  @override
  Future<ResumeData> translateResumeData(
    ResumeData data,
    String targetLanguage,
  ) async {
    // Aqui, você faria chamadas à API para traduzir cada campo de texto.
    // Por simplicidade, vamos simular a tradução de alguns campos.
    // Em um cenário real, você faria uma chamada para cada campo ou os agruparia.

    final objectivePrompt =
        'Translate the following text to $targetLanguage: "${data.objective}"';
    // final objectiveRequest = CompleteText(prompt: objectivePrompt, model: Model.textDavinci3);
    // final objectiveResponse = await _openAI.onCompletion(request: objectiveRequest);
    // final translatedObjective = objectiveResponse?.choices.first.text.trim() ?? data.objective;

    // Simulação para o exemplo:
    final translatedObjective =
        '${data.objective} (Translated to $targetLanguage)';

    // Retorna uma CÓPIA dos dados com os campos traduzidos.
    return data.copyWith(
      objective: translatedObjective,
      // Repita o processo para outros campos: experience.description, education.degree, etc.
    );
  }
}
