# Histórico de Desenvolvimento e Contexto Atual

*Última atualização: 2025-10-03*

Este documento serve como um registro do estado atual do desenvolvimento e das decisões de arquitetura para que qualquer pessoa (ou IA) possa rapidamente entender o contexto e dar continuidade à tarefa.

## 1. Visão Geral do Projeto

O **IntelliResume** é um aplicativo Flutter multiplataforma para criação de currículos, com funcionalidades de IA, monetização e foco em acessibilidade.

## 2. Estrutura do Projeto (Mono-repo)

Para facilitar o desenvolvimento, o projeto foi organizado em uma estrutura de mono-repositório. O frontend e o backend estão na mesma pasta raiz, mas serão mantidos em repositórios Git separados.

- **/frontend/**: Contém a aplicação principal em Flutter (IntelliResume).
- **/backend/**: Contém a função serverless Node.js (para o webhook do Stripe) a ser implantada na Vercel.

## 3. Tarefa Atual: Refatoração da Camada de Autenticação

O objetivo é alinhar a lógica de autenticação com o padrão **Clean Architecture** adotado no projeto, desacoplando a lógica de negócios da UI e das fontes de dados.

### 3.1. Problema Identificado

- A lógica de autenticação (login, cadastro, etc.) estava acoplada à camada de apresentação (UI).
- A falta de uma abstração clara dificultava a manutenção e a testabilidade do código.
- O `user_provider.dart` não estava reagindo corretamente às mudanças de estado de autenticação, causando problemas na exibição do perfil do usuário.

### 3.2. Solução Adotada

- **Camada de Domínio:** Definido um contrato de repositório (`AuthRepository`) que estabelece as operações de autenticação necessárias para a aplicação, sem se prender a uma implementação específica.
- **Camada de Dados:** Criada uma implementação concreta (`AuthRepositoryImpl`) que utiliza o Firebase Auth para executar as operações definidas no contrato.
- **Casos de Uso:** Criados casos de uso para cada funcionalidade de autenticação (ex: `SignInUseCase`, `SignUpUseCase`, `SignOutUseCase`, `GetAuthStateChangesUseCase`, `GetCurrentUserUseCase`, `SendPasswordResetUseCase`).
- **Injeção de Dependência:** Registrados os novos repositórios e casos de uso como providers no Riverpod (`data_provider.dart`).
- **Reatividade do Perfil do Usuário:** Refatorado o `UserProfileNotifier` (`user_provider.dart`) para ser totalmente reativo às mudanças de estado de autenticação, garantindo que o perfil do usuário seja carregado e atualizado automaticamente.
- **Refatoração da UI:** As páginas de `LoginPage`, `SignupPage` e os widgets `LayoutTemplate` e `SideMenu` foram atualizados para utilizar os novos casos de uso e providers, removendo a dependência direta do `AuthService` antigo.

## 4. Status e Próximos Passos

Este é o checklist do progresso da refatoração.

- [x] **(Concluído)** Definição da interface `AuthRepository` em `lib/domain/repositories/auth_repository.dart`.
- [x] **(Concluído)** Implementação do `AuthRepositoryImpl` com a lógica do Firebase em `lib/domain/repositories/auth_repository_impl.dart`.
- [x] **(Concluído)** Criar os casos de uso de autenticação (ex: `SignIn`, `SignUp`, `SignOut`) na pasta `lib/domain/usecases/`.
- [x] **(Concluído)** Mover o arquivo `auth_repository_impl.dart` para a pasta `lib/data/repositories/` para seguir corretamente a estrutura da Clean Architecture.
- [x] **(Concluído)** Refatorar os widgets e páginas da camada de apresentação para utilizarem os novos casos de uso.
- [x] **(Concluído)** Atualizar o arquivo de injeção de dependência (`lib/di.dart`) com os novos providers para os repositórios e casos de uso.

---

## 5. Tarefa Concluída: Implementação do Fluxo de Pagamento Multiplataforma

O objetivo foi implementar um fluxo de pagamento funcional e robusto com Stripe, abordando desafios de compatibilidade multiplataforma e comunicação entre frontend e backend.

### 5.1. Desafios Superados

1.  **Fluxo Mobile vs. Web:** A implementação inicial com `PaymentSheet` do `flutter_stripe` não era compatível com a web. A solução foi criar um fluxo condicional:
    *   **Mobile:** Utiliza a `PaymentSheet` nativa, chamando o endpoint `/api/create-payment-intent`.
    *   **Web:** Redireciona para o Stripe Checkout via `url_launcher`, chamando o endpoint `/api/create-checkout-session`.
2.  **Erro de CORS:** Durante o desenvolvimento web, as chamadas do frontend para a API de backend local (`localhost:3000`) eram bloqueadas pelo navegador devido à política de CORS. O problema foi resolvido no backend Node.js/Express com a adição do middleware `cors`.

### 5.2. Status Final

- [x] **(Concluído)** O frontend suporta ambos os fluxos de pagamento (web e mobile).
- [x] **(Concluído)** Os endpoints de backend (`/api/create-payment-intent`, `/api/create-checkout-session`) e o webhook de confirmação estão implementados e funcionais.
- [ ] **(Pendente - Configuração Final)**: Ajustar as URLs de redirecionamento (`SUCCESS_URL`, `CANCEL_URL`) no arquivo `.env` do backend para o ambiente de produção.

---

## 6. Tarefa Concluída: Correção da Exibição de Dados no Painel da IA

O objetivo foi investigar e corrigir por que as informações do usuário não estavam sendo refletidas na string de pré-visualização do currículo no painel do assistente de IA.

### 6.1. Diagnóstico e Solução

- **Problema:** A análise revelou uma inconsistência. A função que enviava os dados para a IA (`_runAi`) combinava corretamente os dados do perfil do usuário com os do currículo. No entanto, a função que exibia os dados na tela (`_buildResultContent`) usava apenas os dados do currículo, omitindo as informações pessoais.
- **Solução:** O widget `_buildResultContent` em `lib/presentation/widgets/ai_assistant_panel.dart` foi modificado para replicar a lógica da função `_runAi`. Ele agora busca o perfil do usuário (`userProfileProvider`) e o combina com os dados do currículo (`localResumeProvider`) antes de gerar e exibir a string formatada. Isso garante que a pré-visualização no painel da IA seja idêntica aos dados enviados para análise.

### 6.2. Status Final

- [x] **(Concluído)** A exibição dos dados no painel da IA foi corrigida e agora inclui as informações pessoais do usuário, resolvendo a inconsistência visual.
