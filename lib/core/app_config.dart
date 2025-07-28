/// Classe para centralizar o acesso a variáveis de ambiente.
class AppConfig {
  // Lê a chave da API da OpenAI a partir das variáveis de ambiente
  // passadas durante a compilação/execução.
  static const openApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '', // Valor padrão caso não seja fornecida
  );

  // Você pode adicionar outras chaves aqui no futuro (Stripe, etc.)
  // static const stripePublicKey = String.fromEnvironment('STRIPE_PUBLIC_KEY');
}
