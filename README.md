# IntelliResume: Currículos Inteligentes com Flutter & IA

[![Licença](https://img.shields.io/badge/license-Proprietary-blue.svg)](./LICENSE)
[![Plataforma](https://img.shields.io/badge/platform-Flutter%20%7C%20Android%20%7C%20iOS%20%7C%20Web-blue)](https://flutter.dev)
[![Arquitetura](https://img.shields.io/badge/architecture-Clean%20Architecture-green)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

O IntelliResume é uma aplicação multiplataforma (PWA e Mobile) construída com Flutter, projetada para simplificar e aprimorar a criação de currículos profissionais. A plataforma se destaca pelo uso de Inteligência Artificial para oferecer recursos avançados e por um forte compromisso com a acessibilidade.

## 🗺️ Roadmap de Desenvolvimento

Acompanhe o progresso do desenvolvimento do IntelliResume.

- [x] **Fase 1: Fundação e Core**
  - [x] Estrutura do projeto com Clean Architecture.
  - [x] Configuração do Firebase (Auth, Firestore).
  - [x] Funcionalidade de criação e gerenciamento de currículos.
  - [x] Refatoração da camada de autenticação.
- [x] **Fase 2: Funcionalidades Inteligentes e Acessibilidade**
  - [x] Integração com API de IA para avaliação, tradução e correção.
  - [x] Implementação de múltiplos modelos de currículo.
  - [x] Suporte base a leitores de tela (Semântica).
  - [ ] Integração e validação da abordagem para VLibras.
- [x] **Fase 3: Monetização**
  - [x] Implementação do fluxo de pagamento no cliente com Stripe (Web e Mobile).
  - [x] Implementação do endpoint de backend `/create-payment-intent` e `/create-checkout-session`.
  - [x] Implementação do Webhook de pagamento seguro na Vercel.
  - [ ] Testes de ponta a ponta do fluxo de assinatura.
- [ ] **Fase 4: Recursos Pro**
  - [ ] Desenvolvimento do "Modo Estúdio" para edição avançada.
- [ ] **Fase 5: Lançamento**
  - [ ] Publicação nas lojas de aplicativos (Google Play, Apple App Store).
  - [ ] Lançamento da versão PWA.

## 🎯 Motivação e Contribuição para a Comunidade

Este projeto nasceu da necessidade de uma ferramenta moderna, acessível e inteligente para a criação de currículos. O objetivo é oferecer uma solução de alta qualidade que possa ser usada por qualquer pessoa, desde estudantes em busca do primeiro emprego até profissionais experientes.

Para a comunidade de desenvolvedores, este repositório serve como um exemplo prático e robusto de um aplicativo Flutter completo, demonstrando:
- Implementação de **Clean Architecture**.
- Gerenciamento de estado com **Riverpod**.
- Integração com serviços de backend como **Firebase**.
- Implementação de um fluxo de pagamento seguro com **Stripe** e **Vercel**.
- Forte foco em acessibilidade (**a11y**) e internacionalização.

## ✨ Principais Funcionalidades

- **Internacionalização (i18n):** Suporte completo a múltiplos idiomas, com sistema de tradução padrão do Flutter e fácil expansão.
- **Criação e Gerenciamento de Currículos:** Interface intuitiva para montar e editar múltiplos currículos.
- **Modelos Profissionais:** Uma variedade de modelos, incluindo opções gratuitas e premium.
- **Assistência de IA:**
  - **Avaliação:** Analisa o conteúdo do currículo e oferece sugestões de melhoria.
  - **Tradução:** Adapta o currículo para diferentes idiomas.
  - **Correção:** Corrige erros gramaticais e de estilo.
- **Monetização:** Sistema de assinatura com múltiplos níveis (Free, Premium, Pro).
- **Modo Estúdio (Plano Pro):** Editor avançado para personalizar layout, fontes e cores. *(em desenvolvimento)*
- **Acessibilidade:**
  - Suporte a leitores de tela (TalkBack, VoiceOver).
  - Tradução para a Língua Brasileira de Sinais (Libras). *(integração com VLibras em desenvolvimento)*

## 🤖 Desenvolvimento Assistido por IA

Uma característica única deste projeto é que seu desenvolvimento foi **intensamente assistido por uma Inteligência Artificial (Gemini)**. A IA foi utilizada como uma ferramenta de pair programming para:
- **Tomada de Decisões Arquiteturais:** Discutir e decidir sobre a melhor arquitetura para funcionalidades como o sistema de pagamento seguro.
- **Geração de Código:** Escrever boilerplate, funções completas e código de configuração.
- **Debugging e Refatoração:** Analisar problemas e sugerir melhorias no código existente.
- **Criação de Documentação:** Gerar e atualizar arquivos como este `README.md`.

Este projeto é um case de como desenvolvedores podem alavancar IAs para acelerar o desenvolvimento e melhorar a qualidade do software.

## 🛠️ Tecnologias Utilizadas

- **Frontend:** Flutter
- **Gerenciamento de Estado:** Riverpod
- **Navegação:** GoRouter
- **Backend & Banco de Dados:** Firebase (Firestore, Authentication)
- **Função de Webhook Segura:** Node.js/Express na Vercel
- **Gateway de Pagamento:** Stripe
- **Inteligência Artificial:** Gemini / OpenAI

## 🚀 Começando

### 1. Clone o Repositório
```bash
git clone https://github.com/seu-usuario/intelliresume.git
cd intelliresume
```

### 2. Instale as Dependências
```bash
flutter pub get
```

### 3. Configure o Firebase
- Crie um projeto no console do Firebase.
- Configure seus aplicativos (Android, iOS, Web).
- Baixe o `google-services.json` (para Android) e o `GoogleService-Info.plist` (para iOS) e coloque-os nos diretórios corretos (`android/app/` e `ios/Runner/`).

### 4. Configure as Variáveis de Ambiente
- Na raiz do projeto, copie o arquivo `.env.example` para um novo arquivo chamado `.env`.
  ```bash
  cp .env.example .env
  ```
- Abra o arquivo `.env` e insira suas chaves de API (OpenAI, Stripe, etc.).

### 5. Execute a Aplicação
```bash
flutter run
```
