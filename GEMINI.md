# Documentação do Projeto IntelliResume

*Última atualização: 2025-10-15*

<!-- 
Este documento serve como uma fonte central de verdade para o projeto IntelliResume.
Ele é projetado para ser lido tanto por humanos quanto por assistentes de IA, 
fornecendo contexto claro sobre a arquitetura, funcionalidades e configuração do projeto.
-->

## 1. Visão Geral do Projeto

O IntelliResume é uma aplicação multiplataforma (PWA e Mobile) construída com Flutter, projetada para simplificar e aprimorar a criação de currículos profissionais. A plataforma se destaca pelo uso de Inteligência Artificial para oferecer recursos avançados e por um forte compromisso com a acessibilidade.

## 2. Arquitetura e Padrões

### 2.1. Clean Architecture
O projeto adota o padrão **Clean Architecture** para garantir um código desacoplado, testável e de fácil manutenção. A lógica é dividida em três camadas principais:

*   **Presentation (Apresentação):** Responsável pela UI e interação com o usuário. Utiliza `flutter_riverpod` para gerenciamento de estado e `go_router` para navegação.
*   **Domain (Domínio):** Contém a lógica de negócio pura e as regras da aplicação (casos de uso, entidades, repositórios abstratos).
*   **Data (Dados):** Lida com a obtenção e o armazenamento de dados através de Repositórios concretos e Fontes de Dados (ex: Firebase Firestore).

### 2.2. Estrutura de Mono-repositório
Para facilitar o desenvolvimento, o projeto foi organizado em uma estrutura de mono-repositório, com o frontend e o backend localizados na mesma pasta raiz, mas mantidos em repositórios Git separados.

- **/frontend/**: Contém a aplicação principal em Flutter (IntelliResume).
- **/backend/**: Contém a função serverless Node.js para o webhook de pagamento.

## 3. Funcionalidades e Serviços Chave

### 3.1. Principais Funcionalidades Implementadas

*   **Criação e Gerenciamento de Currículos:** Interface intuitiva para montar e editar múltiplos currículos.
*   **Internacionalização (i18n):** Suporte completo a múltiplos idiomas, com sistema de tradução padrão do Flutter e fácil expansão.
*   **Modelos Profissionais:** Oferece uma variedade de modelos de currículos, incluindo opções gratuitas e premium.
*   **Assistência de IA:**
    *   **Avaliação:** Analisa o conteúdo do currículo e oferece sugestões de melhoria.
    *   **Tradução:** Traduz o currículo para diferentes idiomas.
    *   **Correção:** Corrige erros gramaticais e de estilo.
*   **Monetização:** Sistema de assinatura com três níveis (Free, Premium, Pro) via Stripe.
*   **Autenticação:** Suporte para E-mail/Senha, Google Sign-In e Facebook Login.
*   **Acessibilidade:**
    *   Suporte a leitores de tela (TalkBack, VoiceOver).
    *   Tema de alto contraste, escala de fonte e texto em negrito.

### 3.2. Funcionalidades em Desenvolvimento

*   **Modo Estúdio (Plano Pro):** Editor avançado para personalizar o layout, fontes e cores.
*   **Integração com VLibras:** Tradução para a Língua Brasileira de Sinais.

### 3.3. Integração com IA (`AIService`)

Os recursos de IA são centralizados através de uma abstração (`AIService`) para facilitar a troca de provedores. O projeto está preparado para usar diferentes implementações, como `OpenAIService` ou `GeminiService`, bastando atualizar o provedor de injeção de dependência no Riverpod.

### 3.4. Monetização e Verificação de Pagamentos (Arquitetura Segura)

O fluxo de compra de assinaturas foi desenhado para ser seguro, evitando fraudes através da verificação server-side.

*   **Problema Resolvido:** A verificação de pagamento nunca ocorre no dispositivo do cliente.
*   **Arquitetura de Webhook:**
    1.  O App Flutter (frontend) inicia a compra (via `flutter_stripe` no mobile ou redirecionamento no web).
    2.  Após o pagamento, o Stripe envia uma notificação (webhook) para um endpoint seguro hospedado como uma **função serverless na Vercel** (código na pasta `/backend`).
    3.  A função na Vercel verifica a assinatura criptográfica do webhook para garantir sua autenticidade.
    4.  Com a confirmação, a função usa o **Firebase Admin SDK** para se conectar de forma segura ao Firestore e atualizar o status do usuário (ex: `isPremium: true`).
    5.  O app, ouvindo em tempo real, detecta a mudança no Firestore e libera as funcionalidades premium.

## 4. Dependências Principais

*   `flutter_riverpod`: Gerenciamento de estado.
*   `go_router`: Navegação por rotas.
*   `firebase_auth`, `cloud_firestore`: Backend e autenticação.
*   `flutter_gemini`, `chat_gpt_sdk`: SDKs para integração com APIs de IA.
*   `flutter_stripe`: Processamento de pagamentos no mobile.
*   `url_launcher`: Para abrir links externos (usado no fluxo de pagamento web).
*   `hive`: Banco de dados local.

## 5. Configuração e Execução (Getting Started)

### 5.1. Frontend (App Flutter)

1.  **Clone o Repositório:** `git clone https://github.com/seu-usuario/intelliresume.git`
2.  **Navegue para a pasta do frontend:** `cd intelliresume/frontend`
3.  **Instale Dependências:** `flutter pub get`
4.  **Configure o Firebase:** Siga as instruções no console do Firebase para adicionar os arquivos `google-services.json` (Android) e `GoogleService-Info.plist` (iOS).
5.  **Configure Variáveis de Ambiente:** Copie `.env.example` para `.env` e preencha suas chaves de API (Stripe, IA, etc.).
6.  **Execute a Aplicação:** `flutter run`

### 5.2. Backend (Função Vercel)

1.  **Navegue para a pasta do backend:** `cd intelliresume/backend`
2.  **Instale Dependências:** `npm install`
3.  **Configure as Variáveis de Ambiente:** O deploy será feito na Vercel. As variáveis (segredos do Stripe, credenciais do Firebase Service Account) devem ser configuradas diretamente no painel de controle do projeto na Vercel.
4.  **Deploy:** Conecte o repositório do backend à Vercel para deploy automático.