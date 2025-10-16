# Histórico de Desenvolvimento e Contexto Atual

*Última atualização: 2025-10-15*

Este documento serve como um registro do estado atual do desenvolvimento e das decisões de arquitetura para que qualquer pessoa (ou IA) possa rapidamente entender o contexto e dar continuidade à tarefa.

## 1. Visão Geral do Projeto

O **IntelliResume** é um aplicativo Flutter multiplataforma para criação de currículos, com funcionalidades de IA, monetização e foco em acessibilidade.

## 2. Estrutura do Projeto (Mono-repo)

Para facilitar o desenvolvimento, o projeto foi organizado em uma estrutura de mono-repositório. O frontend e o backend estão na mesma pasta raiz, mas serão mantidos em repositórios Git separados.

- **/frontend/**: Contém a aplicação principal em Flutter (IntelliResume).
- **/backend/**: Contém a função serverless Node.js (para o webhook do Stripe) a ser implantada na Vercel.

## 3. Análise do Estado Atual do Projeto

Uma análise completa do projeto foi realizada para determinar o estado atual de implementação.

### 3.1. Arquitetura e Tecnologias

*   **Arquitetura:** O projeto segue o padrão **Clean Architecture**, com uma separação clara entre as camadas de **Domain**, **Data** e **Presentation**.
*   **Gerenciamento de Estado:** Utiliza **Flutter Riverpod** para injeção de dependência e gerenciamento de estado de forma reativa.
*   **Navegação:** A navegação é gerenciada pelo pacote **GoRouter**, permitindo uma navegação baseada em rotas e URLs.
*   **Backend:** O backend é baseado em **Firebase** (Authentication e Firestore) para persistência de dados e autenticação de usuários.
*   **Pagamentos:** A monetização é implementada com **Stripe**, com suporte para pagamentos mobile (usando `flutter_stripe`) e web (redirecionamento para o Stripe Checkout).
*   **IA:** A integração com serviços de IA (Gemini) está presente, com um `AIAssistantPanel` integrado na tela de edição de currículo.
*   **Banco de Dados Local:** Utiliza **Hive** para armazenamento de dados locais.

### 3.2. Funcionalidades Implementadas

*   **Autenticação:**
    *   Fluxo completo de autenticação com E-mail/Senha, Google Sign-In e Facebook Login.
    *   Refatoração da camada de autenticação para seguir a Clean Architecture, com `AuthRepository` e casos de uso.
*   **Gerenciamento de Currículos:**
    *   Criação, edição e visualização de múltiplos currículos.
    *   Formulário de edição de currículo com múltiplos campos (informações pessoais, experiência, educação, etc.).
    *   Preview do currículo em tempo real (em telas largas) ou através de um diálogo (em telas estreitas).
*   **Dashboard (Página Inicial):**
    *   Exibe uma saudação ao usuário.
    *   Apresenta uma lista de currículos recentes.
    *   Oferece ações rápidas para navegar para outras partes do aplicativo.
*   **Perfil do Usuário:**
    *   Exibe as informações do perfil do usuário (nome, e-mail, foto).
    *   Mostra o status da assinatura (Free/Premium).
    *   Permite o upgrade para o plano Premium.
*   **Monetização:**
    *   Página de compra para upgrade de plano.
    *   Fluxo de pagamento implementado para web e mobile.
*   **Assistente de IA:**
    *   Painel de assistência de IA integrado na página de edição de currículo.
*   **Acessibilidade:**
    *   Suporte para temas de alto contraste.
    *   Escala de fonte e texto em negrito ajustáveis.

### 3.3. Tarefas Concluídas Recentemente

*   **Refatoração da Camada de Autenticação:** Alinhamento com a Clean Architecture.
*   **Implementação do Fluxo de Pagamento Multiplataforma:** Suporte para Stripe na web e no mobile.
*   **Correção da Exibição de Dados no Painel da IA:** Garantia de consistência entre os dados exibidos e os enviados para a IA.

## 4. Status e Próximos Passos

O projeto possui uma base sólida e funcional, com as principais funcionalidades implementadas. Os próximos passos podem incluir:

*   Finalizar a integração com VLibras.
*   Desenvolver o "Modo Estúdio" para edição avançada de currículos.
*   Realizar testes de ponta a ponta.
*   Preparar para o lançamento nas lojas de aplicativos e como PWA.