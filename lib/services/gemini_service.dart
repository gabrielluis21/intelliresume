
import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/services/ai_services.dart';

/// Implementação concreta dos serviços de IA usando a API do Google Gemini.
/// Implementa ambas as interfaces para reutilizar a conexão e a lógica.
class GeminiService implements AIService, TemplateTranslationService {
  final GenerativeModel _model;
  final bool _isInitialized;

  GeminiService({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-1.0-pro', // ou outro modelo apropriado
          apiKey: apiKey,
        ),
        _isInitialized = apiKey.isNotEmpty;

  @override
  Future<String> correct(String text) async {
    if (!_isInitialized) return text;

    final prompt =
        'Corrija erros gramaticais e de estilo no texto a seguir, retornando apenas o texto corrigido: "$text"';
    final content = [Content.text(prompt)];

    try {
      final response = await _model.generateContent(content);
      return response.text ?? text;
    } catch (e) {
      print('Erro ao chamar a API Gemini: $e');
      return text; // Retorna o texto original em caso de erro
    }
  }

  @override
  Future<String> evaluate(String text) async {
    if (!_isInitialized) return 'Serviço de IA não inicializado.';

    final prompt =
        'Você é um recrutador sênior. Avalie o seguinte texto de currículo, fornecendo sugestões claras e concisas para melhoria: "$text"';
    final content = [Content.text(prompt)];

    try {
      final response = await _model.generateContent(content);
      return response.text ?? 'Não foi possível obter uma avaliação.';
    } catch (e) {
      print('Erro ao chamar a API Gemini: $e');
      return 'Ocorreu um erro ao processar a avaliação. Tente novamente.';
    }
  }

  @override
  Future<String> translate(String text, String to) async {
    if (!_isInitialized) return text;

    final prompt =
        'Traduza o texto a seguir para $to, mantendo nomes e formatação. Retorne apenas o texto traduzido: "$text"';
    final content = [Content.text(prompt)];

    try {
      final response = await _model.generateContent(content);
      return response.text ?? text;
    } catch (e) {
      print('Erro ao chamar a API Gemini para tradução: $e');
      return text; // Retorna o texto original em caso de erro
    }
  }

  @override
  Future<ResumeData> translateResumeData(
    ResumeData data,
    String targetLanguage,
  ) async {
    if (!_isInitialized) {
      print("Gemini Service not initialized. Skipping translation.");
      return data;
    }

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
      // Adicione outros campos de texto livre aqui conforme necessário
    };

    final prompt = """
    Translate the text fields in the following JSON object to '$targetLanguage'.
    Return ONLY a valid JSON object with the exact same structure, but with the string values translated.
    Do not add any explanation or introductory text.

    Original JSON:
    ${jsonEncode(textsToTranslate)}
    """;

    final content = [Content.text(prompt)];

    try {
      final response = await _model.generateContent(content);
      final resultText = response.text?.trim() ?? '{}';

      final translatedJson = jsonDecode(resultText) as Map<String, dynamic>;

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
      print("Error during Gemini translation: $e");
      return data;
    }
  }
}
