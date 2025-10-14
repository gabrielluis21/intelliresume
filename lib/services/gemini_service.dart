import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/services/ai_services.dart';

/// Implementação concreta dos serviços de IA usando a API do Google Gemini
/// com o pacote flutter_gemini.
class GeminiService implements AIService, TemplateTranslationService {
  final gemini = Gemini.instance;

  @override
  Future<String> correct(String text) async {
    final prompt =
        'Corrija erros gramaticais e de estilo no texto a seguir, retornando apenas o texto corrigido: "$text"';

    try {
      final response = await gemini.text(prompt);
      return response?.output ?? text;
    } catch (e) {
      print('Erro ao chamar a API Gemini: $e');
      // Retorna o texto original em caso de erro
      throw Exception('Failed to correct text with Gemini: $e');
    }
  }

  @override
  Future<String> evaluate(String text) async {
    final prompt =
        'Você é um recrutador sênior. Avalie o seguinte texto de currículo, fornecendo sugestões claras e concisas para melhoria em formato de bullet points: "$text"';

    try {
      final response = await gemini.text(prompt);
      return response?.output ?? 'Não foi possível obter uma avaliação.';
    } catch (e) {
      print('Erro ao chamar a API Gemini: $e');
      throw Exception('Failed to evaluate text with Gemini: $e');
    }
  }

  @override
  Future<String> translate(String text, String to) async {
    final prompt =
        'Traduza o texto a seguir para $to, mantendo nomes e formatação. Retorne apenas o texto traduzido: "$text"';

    try {
      final response = await gemini.text(prompt);
      return response?.output ?? text;
    } catch (e) {
      print('Erro ao chamar a API Gemini para tradução: $e');
      throw Exception('Failed to translate text with Gemini: $e');
    }
  }

  @override
  Future<ResumeData> translateResumeData(
    ResumeData data,
    String targetLanguage,
  ) async {
    // Para a tradução de dados estruturados, a abordagem de JSON ainda é válida.
    final textsToTranslate = {
      "objective": data.objective,
      "experiences": data.experiences
          ?.map((e) => {"position": e.position, "description": e.description})
          .toList(),
      "educations": data.educations
          ?.map((e) => {"degree": e.degree, "description": e.description})
          .toList(),
      "projects": data.projects
          ?.map((p) => {"name": p.name, "description": p.description})
          .toList(),
      "certificates": data.certificates
          ?.map((c) => {"courseName": c.courseName})
          .toList(),
    };

    final prompt = """
    Translate the text fields in the following JSON object to '$targetLanguage'.
    Return ONLY a valid JSON object with the exact same structure, but with the string values translated.
    Do not add any explanation, introductory text, or markdown formatting like ```json.

    Original JSON:
    ${jsonEncode(textsToTranslate)}
    """;

    try {
      final response = await gemini.text(prompt);
      final resultText = response?.output?.trim() ?? '{}';
      
      final translatedJson = jsonDecode(resultText) as Map<String, dynamic>;

      return data.copyWith(
        objective: translatedJson['objective'] ?? data.objective,
        experiences: data.experiences?.asMap().entries.map((entry) {
          int index = entry.key;
          Experience originalExp = entry.value;
          return originalExp.copyWith(
            position: translatedJson['experiences']?[index]?['position'] ??
                originalExp.position,
            description:
                translatedJson['experiences']?[index]?['description'] ??
                    originalExp.description,
          );
        }).toList(),
        educations: data.educations?.asMap().entries.map((entry) {
          int index = entry.key;
          Education originalEdu = entry.value;
          return originalEdu.copyWith(
            degree: translatedJson['educations']?[index]?['degree'] ??
                originalEdu.degree,
            description:
                translatedJson['educations']?[index]?['description'] ??
                    originalEdu.description,
          );
        }).toList(),
        projects: data.projects?.asMap().entries.map((entry) {
          int index = entry.key;
          Project originalProj = entry.value;
          return originalProj.copyWith(
            name: translatedJson['projects']?[index]?['name'] ??
                originalProj.name,
            description:
                translatedJson['projects']?[index]?['description'] ??
                    originalProj.description,
          );
        }).toList(),
        certificates: data.certificates?.asMap().entries.map((entry) {
          int index = entry.key;
          Certificate originalCert = entry.value;
          return originalCert.copyWith(
            courseName: translatedJson['certificates']?[index]?['courseName'] ??
                originalCert.courseName,
          );
        }).toList(),
      );
    } catch (e) {
      print("Error during Gemini translation: $e");
      // Em caso de erro, retorna os dados originais
      return data;
    }
  }
}