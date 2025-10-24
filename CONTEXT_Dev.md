*Última atualização: 2025-10-23*

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
*   **Acessibilidade:**
    *   Suporte para temas de alto contraste.
    *   Escala de fonte e texto em negrito ajustáveis.

### 3.2. Tarefas Concluídas Recentemente

*   **Refatoração do Sistema de Internacionalização (i18n):** Migração completa do sistema manual de i18n para o padrão oficial do Flutter, utilizando arquivos `.arb` e a geração automática de código. A maioria das telas e widgets foram internacionalizadas.
*   **Correção de Erros de Localização:** Corrigidos erros de `undefined_named_parameter`, `not_enough_positional_arguments` e `undefined_getter`, garantindo que as chamadas de internacionalização estejam corretas.
*   **Refatoração da Camada de Autenticação:** Alinhamento com a Clean Architecture.
*   **Implementação do Fluxo de Pagamento Multiplataforma:** Suporte para Stripe na web e no mobile.
*   **Correção da Exibição de Dados no Painel da IA:** Garantia de consistência entre os dados exibidos e os enviados para a IA.
*   **Correção de Bug Crítico na Edição de Currículos:** Resolvido um erro de "Unexpected null value" que ocorria ao criar ou editar um currículo, tornando o modelo de dados mais robusto.

## 4. Status e Próximos Passos

O projeto possui uma base sólida e funcional. A internacionalização (i18n) foi concluída.

### 4.1. Internacionalização (i18n)

**Telas/Widgets com internacionalização concluída:**
*   `settings_page.dart`
*   `side_menu.dart`
*   `home_page.dart`
*   `login_page.dart`
*   `signup_page.dart`
*   `resume_preview.dart`
*   `resume_form_page.dart`
*   `export_buttons.dart`
*   `about_section.dart`
*   `buy_page.dart`
*   `edit_profile.dart`
*   `export_page.dart`
*   `export_pdf_page.dart`
*   `history_page.dart`
*   `profile_page.dart`
*   `ai_assistant_panel.dart`
*   `cv_card.dart`
*   `resume_form.dart`
*   `about_me_form.dart`
*   `objective_form.dart`
*   `language_selector.dart`
*   `lib/core/templates/resume_template.dart`
*   `lib/presentation/widgets/layout_template.dart`
*   `lib/presentation/widgets/preview/widgets/certificate_list.dart`
*   `lib/presentation/widgets/preview/widgets/education_list.dart`
*   `lib/presentation/widgets/preview/widgets/experience_list.dart`
*   `lib/presentation/widgets/preview/widgets/project_list.dart`
*   `lib/presentation/widgets/preview/widgets/social_link.dart`
*   `lib/presentation/widgets/pricing/pricing_card.dart`
*   `lib/presentation/widgets/recent_resume_card.dart`
*   `lib/presentation/widgets/template_selector.dart`
*   `lib/web_app/pages/sections/contact_section.dart`
*   `lib/web_app/pages/sections/hero_section.dart`
*   `lib/web_app/pages/web_landing_page.dart`