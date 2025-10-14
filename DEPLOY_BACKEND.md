# Guia de Deploy do Backend (Node.js API) na Vercel

Este documento detalha o passo a passo para publicar a API do backend, que está na pasta `/backend`, em um ambiente de produção gratuito na [Vercel](https://vercel.com).

## Pré-requisitos

1.  **Conta na Vercel:** Crie uma conta gratuita, você pode usar sua conta do GitHub para facilitar.
2.  **Conta no GitHub:** Essencial para conectar o projeto à Vercel.
3.  **Git e Node.js:** Tenha o Git e o Node.js instalados na sua máquina.

---

## Passo 1: Preparar o Backend como um Repositório Git Separado

A Vercel funciona melhor importando um repositório por projeto. Como nosso backend está em uma subpasta, o ideal é transformá-lo em seu próprio repositório.

1.  **Navegue até a pasta do backend** pelo seu terminal:
    ```bash
    cd ../backend 
    ```
    *(Se você estiver na pasta `frontend`, este comando o levará para a pasta `backend`)*

2.  **Inicie um novo repositório Git:**
    ```bash
    git init
    ```

3.  **Crie um arquivo `.gitignore`** para ignorar a pasta `node_modules` e arquivos `.env`:
    *   Crie um arquivo chamado `.gitignore` na pasta `/backend`.
    *   Adicione o seguinte conteúdo a ele:
        ```
        # Dependencies
        /node_modules

        # Environment variables
        .env
        ```

4.  **Adicione e "commite" seus arquivos:**
    ```bash
    git add .
    git commit -m "Initial backend commit"
    ```

---

## Passo 2: Enviar o Repositório para o GitHub

1.  **Crie um novo repositório no GitHub:**
    *   Vá para o [GitHub](https://github.com/new).
    *   Dê um nome a ele, como `intelliresume-backend`.
    *   Pode ser um repositório privado ou público.
    *   **Não** inicialize com `README` ou `.gitignore`, pois já fizemos isso localmente.

2.  **Conecte seu repositório local ao GitHub e envie os arquivos:**
    *   No seu terminal (ainda na pasta `/backend`), execute os comandos fornecidos pelo GitHub. Eles serão parecidos com estes:
    ```bash
    git remote add origin https://github.com/SEU-USUARIO/intelliresume-backend.git
    git branch -M main
    git push -u origin main
    ```
    *(Substitua a URL pela URL do seu repositório)*.

---

## Passo 3: Fazer o Deploy na Vercel

1.  **Acesse seu [Dashboard da Vercel](https://vercel.com/dashboard)**.

2.  **Importe o projeto:**
    *   Clique em **"Add New..." -> "Project"**.
    *   Encontre o repositório `intelliresume-backend` que você acabou de criar e clique em **"Import"**.

3.  **Configure o projeto:**
    *   A Vercel deve detectar automaticamente que é um projeto Node.js. Você não precisa mudar as configurações de build.
    *   **A parte mais importante é configurar as Variáveis de Ambiente.** Vá para a seção **"Environment Variables"**.
    *   Adicione todas as chaves que estão no seu arquivo `.env.example` ou `.env` local. Isso inclui:
        *   `STRIPE_SECRET_KEY`
        *   `STRIPE_WEBHOOK_SECRET`
        *   `SUCCESS_URL` (Ex: `https://seu-app-frontend.com/sucesso`)
        *   `CANCEL_URL` (Ex: `https://seu-app-frontend.com/cancelou`)
        *   **Credenciais do Firebase:** Para a credencial do Firebase (o JSON da Service Account), a maneira mais fácil é copiar todo o conteúdo do arquivo JSON e colar no campo "Value" de uma nova variável de ambiente (ex: `FIREBASE_SERVICE_ACCOUNT_JSON`).

4.  **Clique em "Deploy"**.

A Vercel irá instalar as dependências (`npm install`) e implantar sua API como uma função serverless.

---

## Passo 4: Pós-Deploy

1.  **Obtenha a URL de produção:** Após o deploy, a Vercel fornecerá a URL principal do seu projeto (ex: `https://intelliresume-backend.vercel.app`).

2.  **Atualize o Frontend:** No seu aplicativo Flutter, atualize a variável de ambiente que aponta para a API para usar esta nova URL da Vercel.

3.  **Atualize o Webhook no Stripe:**
    *   Vá para o seu [Dashboard do Stripe](https://dashboard.stripe.com/).
    *   Vá para a seção "Developers" -> "Webhooks".
    *   Adicione um novo endpoint ou atualize o existente.
    *   No campo "Endpoint URL", coloque a URL do seu webhook na Vercel (ex: `https://intelliresume-backend.vercel.app/api/stripe-webhook`).
    *   Selecione os eventos que você precisa ouvir (como `checkout.session.completed`).

Pronto! Seu backend estará no ar e conectado ao seu frontend e ao Stripe.
