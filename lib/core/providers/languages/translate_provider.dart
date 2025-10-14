// Abstração para o serviço de tradução de currículos com suporte a Riverpod
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';

abstract class ResumeTranslationService {
  Future<ResumeData> translate(ResumeData resume, String targetLang);
}

final openAITranslatorProvider = Provider<ResumeTranslationService>((ref) {
  return OpenAIResumeTranslator(apiKey: ref.watch(openAIApiKeyProvider));
});

final deepLTranslatorProvider = Provider<ResumeTranslationService>((ref) {
  return DeepLResumeTranslator(apiKey: ref.watch(deepLApiKeyProvider));
});

final fallbackTranslatorProvider = Provider<ResumeTranslationService>((ref) {
  return FallbackTranslator([
    ref.watch(openAITranslatorProvider),
    ref.watch(deepLTranslatorProvider),
  ]);
});

// Providers for API Keys
final openAIApiKeyProvider = Provider<String>((ref) => 'SUA_CHAVE_OPENAI');
final deepLApiKeyProvider = Provider<String>((ref) => 'SUA_CHAVE_DEEPL');

class OpenAIResumeTranslator implements ResumeTranslationService {
  final String apiKey;

  OpenAIResumeTranslator({required this.apiKey});

  @override
  Future<ResumeData> translate(ResumeData resume, String targetLang) async {
    final uri = Uri.parse("https://api.openai.com/v1/chat/completions");
    final body = {
      "model": "gpt-4-turbo",
      "messages": [
        {
          "role": "system",
          "content":
              "You are a resume translator. Translate this resume content to $targetLang keeping the tone professional.",
        },
        {"role": "user", "content": jsonEncode(resume.toMap())},
      ],
      "temperature": 0.3,
    };

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    final reply = data['choices'][0]['message']['content'];
    final translatedJson = jsonDecode(reply);

    return ResumeData.fromJson(translatedJson);
  }
}

class DeepLResumeTranslator implements ResumeTranslationService {
  final String apiKey;

  DeepLResumeTranslator({required this.apiKey});

  @override
  Future<ResumeData> translate(ResumeData resume, String targetLang) async {
    Future<String> translateText(String text) async {
      final uri = Uri.parse("https://api-free.deepl.com/v2/translate");
      final response = await http.post(
        uri,
        headers: {"Authorization": "DeepL-Auth-Key $apiKey"},
        body: {"text": text, "target_lang": targetLang.toUpperCase()},
      );
      final data = jsonDecode(response.body);
      return data["translations"][0]["text"];
    }

    return ResumeData(
      personalInfo: UserProfile(
        name: await translateText(resume.personalInfo!.name!),
        email: resume.personalInfo?.email,
        phone: resume.personalInfo?.phone,
      ),
      socials: resume.socials,
      objective: await translateText(resume.objective!),
      educations: await Future.wait(
        resume.educations!.map(
          (e) async => e.copyWith(
            degree: await translateText(e.degree!),
            school: await translateText(e.school!),
          ),
        ),
      ),
      experiences: await Future.wait(
        resume.experiences!.map(
          (e) async => e.copyWith(
            position: await translateText(e.position!),
            company: await translateText(e.company!),
            description: await translateText(e.description ?? ''),
          ),
        ),
      ),
      skills: await Future.wait(
        resume.skills!.map(
          (e) async => e.copyWith(
            name: await translateText(e.name!),
            level: await translateText(e.level!),
          ),
        ),
      ),
      projects: await Future.wait(
        resume.projects!.map(
          (p) async => p.copyWith(
            name: await translateText(p.name!),
            description: await translateText(p.description ?? ''),
          ),
        ),
      ),
      certificates: await Future.wait(
        resume.certificates!.map(
          (c) async => c.copyWith(
            courseName: await translateText(c.courseName!),
            institution: await translateText(c.institution!),
            workload: await translateText(c.workload ?? ''),
          ),
        ),
      ),
      languages: resume.languages,
    );
  }
}

class FallbackTranslator implements ResumeTranslationService {
  final List<ResumeTranslationService> translators;

  FallbackTranslator(this.translators);

  @override
  Future<ResumeData> translate(ResumeData resume, String targetLang) async {
    for (final translator in translators) {
      try {
        return await translator.translate(resume, targetLang);
      } catch (e) {
        continue;
      }
    }
    throw Exception("All translators failed.");
  }
}
