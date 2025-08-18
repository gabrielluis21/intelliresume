import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:intelliresume/data/models/cv_data.dart';

/// Contrato para serviços de IA voltados ao usuário (contam interações).
abstract class AIService {
  Future<String> evaluate(String text);
  Future<String> translate(String text, String to);
  Future<String> correct(String text);
}

/// Contrato para o serviço de tradução interna de templates.
/// Não conta como interação de IA para o usuário.
abstract class TemplateTranslationService {
  /// Traduz os campos de texto de um [ResumeData] para um idioma alvo.
  Future<ResumeData> translateResumeData(
    ResumeData data,
    String targetLanguage,
  );
}

/// Implementação concreta dos serviços de IA usando a API da OpenAI.
/// Implementa ambas as interfaces para reutilizar a conexão e a lógica.
class OpenAIService implements AIService, TemplateTranslationService {
  final OpenAI _openAI;
  final bool _isInitialized;

  OpenAIService({required String apiKey})
    : _openAI = OpenAI.instance.build(
        token: apiKey,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
        enableLog: true, // Mantenha true para debug, false para produção
      ),
      _isInitialized = apiKey.isNotEmpty;

  @override
  Future<ResumeData> translateResumeData(
    ResumeData data,
    String targetLanguage,
  ) async {
    if (!_isInitialized) {
      // Se a chave não foi fornecida, retorna os dados originais para não quebrar o app.
      print("OpenAI Service not initialized. Skipping translation.");
      return data;
    }

    // Estratégia eficiente: traduzir tudo em uma única chamada de API.
    // Criamos um objeto JSON com os textos a serem traduzidos.
    final textsToTranslate = {
      "objective": data.objective,
      "experiences":
          data.experiences
              ?.map(
                (e) => {"position": e.position, "description": e.description},
              )
              .toList(),
      "educations":
          data.educations
              ?.map((e) => {"degree": e.degree, "description": e.description})
              .toList(),
      // Adicione outros campos de texto livre aqui
    };

    final prompt = """
    Translate the text fields in the following JSON object to '$targetLanguage'.
    Return ONLY a valid JSON object with the exact same structure, but with the string values translated.
    Do not add any explanation or introductory text.

    Original JSON:
    ${jsonEncode(textsToTranslate)}
    """;

    try {
      final request = ChatCompleteText(
        messages: [
          Map.of({"role": Role.user.name, "content": prompt}),
        ],
        maxToken: 2048,
        model: GptTurboChatModel(),
      );

      final response = await _openAI.onChatCompletion(request: request);
      final resultText =
          response?.choices.first.message?.content.trim() ?? '{}';

      // Decodifica a resposta JSON da IA
      final translatedJson = jsonDecode(resultText) as Map<String, dynamic>;

      // Cria uma cópia dos dados originais e atualiza com os textos traduzidos
      return data.copyWith(
        objective: translatedJson['objective'] ?? data.objective,
        experiences:
            data.experiences?.asMap().entries.map((entry) {
              int index = entry.key;
              Experience originalExp = entry.value;
              return originalExp.copyWith(
                position:
                    translatedJson['experiences']?[index]?['position'] ??
                    originalExp.position,
                description:
                    translatedJson['experiences']?[index]?['description'] ??
                    originalExp.description,
              );
            }).toList(),
        educations:
            data.educations?.asMap().entries.map((entry) {
              int index = entry.key;
              Education originalEdu = entry.value;
              return originalEdu.copyWith(
                degree:
                    translatedJson['educations']?[index]?['degree'] ??
                    originalEdu.degree,
                description:
                    translatedJson['educations']?[index]?['description'] ??
                    originalEdu.description,
              );
            }).toList(),
      );
    } catch (e) {
      print("Error during translation: $e");
      // Em caso de erro, retorna os dados originais para não quebrar a experiência.
      return data;
    }
  }

  @override
  Future<String> correct(String text) async {
    final chat = await _openAI.onChatCompletion(
      request: ChatCompleteText(
        model: GptTurboChatModel(),
        messages: [
          Map.of({
            'role': Role.system,
            'content': 'Corrija erros gramaticais e de estilo:',
          }),
          Map.of({'role': Role.user, 'content': text}),
        ],
      ),
    );
    return chat!.choices.first.message!.content;
  }

  @override
  Future<String> evaluate(String text) async {
    final chat = await _openAI.onChatCompletion(
      request: ChatCompleteText(
        model: GptTurboChatModel(),
        messages: [
          Map.of({
            'role': Role.system,
            'content': 'Você é um recrutador sênior. Avalie o currículo:',
          }),
          Map.of({'role': Role.user, 'content': text}),
        ],
      ),
    );
    return chat!.choices.first.message!.content;
  }

  @override
  Future<String> translate(String text, String to) async {
    final chat = await _openAI.onChatCompletion(
      request: ChatCompleteText(
        model: GptTurboChatModel(),
        messages: [
          Map.of({
            'role': Role.system,
            'content': 'Traduza o texto para $to, mantendo nomes e formatação.',
          }),
          Map.of({'role': Role.user, 'content': text}),
        ],
      ),
    );
    return chat!.choices.first.message!.content;
  }
}
