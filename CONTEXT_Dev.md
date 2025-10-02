# Histórico de Desenvolvimento e Contexto Atual

*Última atualização: 2025-10-02*

Este documento serve como um registro do estado atual do desenvolvimento e das decisões de arquitetura para que qualquer pessoa (ou IA) possa rapidamente entender o contexto e dar continuidade à tarefa.

## 1. Visão Geral do Projeto

O **IntelliResume** é um aplicativo Flutter multiplataforma para criação de currículos, com funcionalidades de IA, monetização e foco em acessibilidade.

## 2. Estrutura do Projeto (Mono-repo)

Para facilitar o desenvolvimento, o projeto foi organizado em uma estrutura de mono-repositório. O frontend e o backend estão na mesma pasta raiz, mas serão mantidos em repositórios Git separados.

- **/frontend/**: Contém a aplicação principal em Flutter (IntelliResume).
- **/backend/**: Contém a função serverless Node.js (para o webhook do Stripe) a ser implantada na Vercel.

## 3. Tarefa Atual: Implementação de Webhook de Pagamento Seguro

O objetivo é corrigir uma falha de segurança crítica no fluxo de monetização antes da publicação do aplicativo.

### 3.1. Problema Identificado

- A verificação do status de uma compra era simulada no front-end, permitindo que usuários mal-intencionados burlassem o sistema para obter acesso a recursos premium gratuitamente.
- A solução com Firebase Cloud Functions foi descartada, pois o plano gratuito "Spark" do Firebase não oferece suporte a essa funcionalidade.

### 3.2. Solução Adotada (Plano B)

- **Plataforma de Hospedagem:** Utilizar uma **função serverless** gratuita na **Vercel**.
- **Tecnologia do Backend:** Um projeto dedicado em **Node.js com Express e TypeScript**, localizado na pasta `/backend/`.
- **Autenticação:** A função na Vercel se autenticará no Firebase de forma segura usando uma **Chave de Conta de Serviço (Service Account)**.
- **Fluxo de Dados:**
  1.  O App Flutter (frontend) gera uma sessão de checkout e redireciona para o Stripe.
  2.  O Stripe, após pagamento, chama o webhook na Vercel (backend).
  3.  A função na Vercel verifica a assinatura do Stripe.
  4.  A função atualiza o documento do usuário no **Firestore** usando o **Firebase Admin SDK**.
  5.  O App Flutter (frontend) reflete a mudança em tempo real.

## 4. Status e Próximos Passos

Este é o checklist do progresso da implementação da solução.

- [x] Análise do problema de segurança.
- [x] Investigação de soluções de baixo custo.
- [x] Decisão da arquitetura final (Vercel Serverless Function).
- [x] Detalhamento do passo a passo para a implementação.
- [x] Geração da chave de serviço (`service-account.json`) do Firebase.
- [x] Criação da estrutura do projeto na pasta `/backend/`.
- [x] Escrita do código da função `api/index.ts`.
- [ ] **(Próximo Passo)** Criação de um repositório **privado** no GitHub para o conteúdo da pasta `/backend/`.
- [ ] Criação da conta na Vercel e importação do projeto a partir do GitHub.
- [ ] Configuração das variáveis de ambiente na Vercel (chaves do Stripe e Firebase).
- [ ] Deploy da função na Vercel.
- [ ] Configuração final do endpoint de webhook no painel do Stripe.
- [ ] Realização de um teste de ponta a ponta.
