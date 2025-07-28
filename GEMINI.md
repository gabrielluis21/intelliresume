# Documentação do Projeto IntelliResume

<!-- 
Este documento serve como uma fonte central de verdade para o projeto IntelliResume.
Ele é projetado para ser lido tanto por humanos quanto por assistentes de IA, 
fornecendo contexto claro sobre a arquitetura, funcionalidades e configuração do projeto.
-->

## 1. Visão Geral do Projeto

O IntelliResume é uma aplicação multiplataforma (PWA e Mobile) construída com Flutter, projetada para simplificar e aprimorar a criação de currículos profissionais. A plataforma se destaca pelo uso de Inteligência Artificial para oferecer recursos avançados e por um forte compromisso com a acessibilidade.

### 1.1. Principais Funcionalidades

*   **Criação e Gerenciamento de Currículos:** Interface intuitiva para montar e editar múltiplos currículos.
*   **Modelos Profissionais:** Oferece uma variedade de modelos de currículos, incluindo opções gratuitas e premium.
*   **Assistência de IA:**
    *   **Avaliação:** Analisa o conteúdo do currículo e oferece sugestões de melhoria.
    *   **Tradução:** Traduz o currículo para diferentes idiomas, adaptando-o a contextos internacionais.
    *   **Correção:** Corrige erros gramaticais e de estilo.
*   **Monetização:** Sistema de assinatura com três níveis (Free, Premium, Pro).
*   **Modo Estúdio (Plano Pro):** Editor avançado que permite ao usuário personalizar o layout, fontes e cores dos modelos de currículo.
*   **Acessibilidade:** Suporte para leitores de tela e tradução para a Língua Brasileira de Sinais (Libras) através do VLibras.

## 2. Arquitetura e Padrões

O projeto adota o padrão **Clean Architecture** para garantir um código desacoplado, testável e de fácil manutenção. A lógica é dividida em três camadas principais:

*   **Presentation (Apresentação):** Responsável pela UI e interação com o usuário.
    *   **Widgets:** Componentes visuais (páginas, cards, botões). Inclui uma `WebLandingPage` responsiva.
    *   **Gerenciamento de Estado:** Utiliza o pacote `flutter_riverpod` para um gerenciamento de estado reativo e escalável.
    *   **Navegação:** Gerenciada pelo `go_router` para navegação baseada em rotas nomeadas.
*   **Domain (Domínio):** Contém a lógica de negócio pura e as regras da aplicação (casos de uso, entidades). É a camada mais interna e não depende de nenhum detalhe de implementação (UI, banco de dados).
*   **Data (Dados):** Lida com a obtenção e o armazenamento de dados.
    *   **Repositórios:** Abstraem as fontes de dados, fornecendo uma interface limpa para a camada de domínio.
    *   **Fontes de Dados:** Implementações concretas para acesso a dados (ex: Firebase Firestore, APIs REST, SharedPreferences).

## 3. Funcionalidades e Serviços Chave

### 3.1. Integração com IA (`AIService`)

Os recursos de IA são centralizados através de uma abstração para facilitar a troca de provedores.

**Padrão de Implementação:**
Para garantir um contrato claro, foi definida uma classe abstrata `AIService`. Qualquer provedor de IA deve estender esta classe.

```dart
// lib/domain/services/ai_service.dart (Exemplo de estrutura)
abstract class AIService {
  Future<String> evaluate(String text);
  Future<String> translate(String text, String to);
  Future<String> correct(String text);
}
```

**Trocando o Provedor de IA:**
1.  **Crie uma nova implementação:** Crie uma classe que estenda `AIService` e implemente os métodos usando o SDK do novo provedor.
    ```dart
    // lib/data/services/openai_service.dart
    import 'package:intelliresume/domain/services/ai_service.dart';

    class OpenAIService implements AIService {
      // ... implementação com o SDK do OpenAI
    }
    ```
2.  **Atualize a Injeção de Dependência:** No seu arquivo de configuração de provedores do Riverpod, troque a implementação fornecida.
    ```dart
    // lib/core/providers.dart
    final aiServiceProvider = Provider<AIService>((ref) {
      // Para trocar, basta substituir a classe aqui.
      // return MyAwesomeAIService();
      return OpenAIService(apiKey: 'SUA_CHAVE');
    });
    ```

### 3.2. Monetização e Compras

O fluxo de compra da assinatura Premium é gerenciado pelo `PurchaseController` (disponibilizado via `purchase_provider`).

*   **Fluxo:** O método `initiatePurchase` tenta abrir uma URL de pagamento primária (ex: Stripe). Se falhar, oferece uma URL de fallback (ex: Mercado Pago) através de um diálogo.
*   **Verificação:** A verificação do status da compra é simulada no front-end, mas em um ambiente de produção, deve ser feita por um backend seguro através de webhooks para evitar fraudes.

### 3.3. Acessibilidade (a11y)

O projeto demonstra um forte compromisso com a acessibilidade.
*   **Semântica no Flutter:** Widgets como `Semantics`, `FocusableActionDetector` e `SelectableText` são usados em toda a aplicação para garantir a compatibilidade com leitores de tela (ex: TalkBack, VoiceOver).
*   **Suporte a VLibras:** Foi criada uma página HTML estática (`assets/landing_page_vlibras.html`) que contém o conteúdo principal da landing page. Esta página integra o plugin do VLibras, que traduz o texto para a Língua Brasileira de Sinais, atendendo à comunidade surda.

## 4. Dependências Principais

As principais dependências do projeto estão listadas no `pubspec.yaml`.

*   `flutter_riverpod`: Gerenciamento de estado.
*   `go_router`: Navegação por rotas.
*   `firebase_auth`, `cloud_firestore`: Backend e autenticação.
*   `chat_gpt_sdk`: SDK para integração com a API da OpenAI (exemplo).
*   `url_launcher`: Para abrir links externos (pagamentos, e-mails).

## 5. Configuração e Execução (Getting Started)

1.  **Clonar o Repositório:**
    ```bash
    git clone https://github.com/seu-usuario/intelliresume.git
    cd intelliresume
    ```
2.  **Instalar Dependências:**
    ```bash
    flutter pub get
    ```
3.  **Configurar o Firebase:**
    *   Crie um projeto no console do Firebase.
    *   Configure seus aplicativos (Android, iOS, Web).
    *   Baixe o `google-services.json` (para Android) e o `GoogleService-Info.plist` (para iOS) e coloque-os nos diretórios corretos (`android/app/` e `ios/Runner/`).

4.  **Configurar Variáveis de Ambiente:**
    *   Obtenha uma chave de API do seu provedor de IA (ex: OpenAI).
    *   **NÃO** coloque a chave diretamente no código. Use variáveis de ambiente através do comando `--dart-define` para segurança.

5.  **Executar a Aplicação:**
    ```bash
    # Exemplo de execução passando a chave de API
    flutter run --dart-define=OPENAI_API_KEY="sua_chave_aqui"
    ```
