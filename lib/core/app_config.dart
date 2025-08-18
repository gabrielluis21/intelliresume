import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Classe para centralizar o acesso a variáveis de ambiente.
class AppConfig {
  // Lê a chave da API da OpenAI a partir do arquivo .env
  static final openApiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  // Lê a chave pública do Stripe a partir do arquivo .env
  static final stripePublicKey = dotenv.env['STRIPE_PUBLIC_KEY'] ?? '';
}