import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/app_config.dart';
import 'package:intelliresume/services/ai_services.dart';
import 'package:intelliresume/services/gemini_service.dart';

/// Provider que instancia o serviço de IA da OpenAI com a chave de API.
final openAIServiceProvider = Provider<OpenAIService>((ref) {
  final apiKey = AppConfig.openApiKey;
  return OpenAIService(apiKey: apiKey);
});

/// Provider que instancia o serviço de IA do Google Gemini com a chave de API.
final geminiServiceProvider = Provider<GeminiService>((ref) {
  final apiKey = AppConfig.geminiApiKey;
  return GeminiService(apiKey: apiKey);
});

/// Provider para o serviço de IA voltado ao usuário.
/// Permite alternar explicitamente entre Gemini e OpenAI via AI_PROVIDER no .env.
/// Se não especificado, prioriza Gemini se a chave estiver disponível.
final aiServiceProvider = Provider<AIService>((ref) {
  final selectedProvider = AppConfig.aiProvider.toLowerCase();

  if (selectedProvider == 'gemini') {
    return ref.watch(geminiServiceProvider);
  } else if (selectedProvider == 'openai') {
    return ref.watch(openAIServiceProvider);
  } else {
    // Lógica de fallback se AI_PROVIDER não for especificado ou for inválido
    if (AppConfig.geminiApiKey.isNotEmpty) {
      return ref.watch(geminiServiceProvider);
    } else {
      return ref.watch(openAIServiceProvider);
    }
  }
});

/// Provider para o serviço de tradução interna de templates.
/// Permite alternar explicitamente entre Gemini e OpenAI via AI_PROVIDER no .env.
/// Se não especificado, prioriza Gemini se a chave estiver disponível.
final templateTranslationServiceProvider = Provider<TemplateTranslationService>(
  (ref) {
    final selectedProvider = AppConfig.aiProvider.toLowerCase();

    if (selectedProvider == 'gemini') {
      return ref.watch(geminiServiceProvider);
    } else if (selectedProvider == 'openai') {
      return ref.watch(openAIServiceProvider);
    } else {
      // Lógica de fallback se AI_PROVIDER não for especificado ou for inválido
      if (AppConfig.geminiApiKey.isNotEmpty) {
        return ref.watch(geminiServiceProvider);
      } else {
        return ref.watch(openAIServiceProvider);
      }
    }
  },
);
