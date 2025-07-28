import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/app_config.dart';
import 'package:intelliresume/services/ai_services.dart';

/// Provider que instancia o serviço de IA com a chave de API.
/// Este é o provedor "mestre" do qual os outros dependem.
final openAIServiceProvider = Provider<OpenAIService>((ref) {
  // Obtém a chave de API da nossa classe de configuração segura.
  final apiKey = AppConfig.openApiKey;
  return OpenAIService(apiKey: apiKey);
});

/// Provider para o serviço de IA voltado ao usuário.
/// Aponta para a implementação do OpenAI.
final aiServiceProvider = Provider<AIService>((ref) {
  return ref.watch(openAIServiceProvider);
});

/// Provider para o serviço de tradução interna de templates.
final templateTranslationServiceProvider = Provider<TemplateTranslationService>(
  (ref) {
    return ref.watch(openAIServiceProvider);
  },
);
