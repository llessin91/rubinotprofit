# Tutorial — configurar Supabase e publicar no GitHub Pages

Este tutorial acompanha o Gold Ledger e explica, desde o início, como conectar o banco de dados e disponibilizar o site. Você não precisa instalar ferramentas para executar a aplicação: é um site estático.

## Parte 1 — Criar e configurar o Supabase

1. Acesse [supabase.com](https://supabase.com/), crie uma conta e um projeto. Guarde a senha do banco em local seguro; ela não é usada no site.
2. No painel do projeto, abra **SQL Editor**, escolha uma consulta nova, copie todo o conteúdo de `supabase/schema.sql` e execute. Isso cria as tabelas `gold_entries` e `gold_goals`, com regras para cada conta acessar somente seus próprios dados.
3. Abra **Project Settings → API** (ou **API Keys**, dependendo da versão do painel). Copie a **Project URL** e a chave pública **anon/public** ou **publishable**. Nunca use nem compartilhe a chave `service_role` ou `secret`.
4. Em **Authentication → URL Configuration**, adicione as URLs onde o site será publicado em **Site URL** e **Redirect URLs**. Exemplo: `https://SEU-USUARIO.github.io/SEU-REPOSITORIO/`. Se também for testar localmente, permita a URL local indicada na Parte 3. Salve as mudanças.
5. Para cadastro com verificação de e-mail, em **Authentication → Providers → Email**, mantenha Email habilitado. Configure o envio de e-mail conforme preferir. Se deixar confirmação obrigatória, após criar a conta abra o link de confirmação enviado antes de entrar. Para testes rápidos, é possível desativar temporariamente a confirmação de e-mail nas configurações de autenticação — reative-a se preferir confirmação.

## Parte 2 — Ligar o site ao projeto Supabase

1. Abra `config.js` em um editor de texto.
2. Substitua os dois valores de exemplo. O conteúdo ficará neste formato:

```js
window.GOLD_CONFIG = {
  supabaseUrl: "https://seu-projeto.supabase.co",
  supabaseAnonKey: "sua-chave-publica-anon-ou-publishable"
};
```

3. Salve. A URL e a chave pública aparecem no navegador, então não são segredos administrativos. As políticas RLS do banco são a barreira de segurança que protege as informações. **Nunca cole a chave `service_role`/`secret` em `config.js`.**

## Parte 3 — Testar no computador (opcional)

É possível abrir `index.html` diretamente no navegador para conferir a interface, mas autenticação pode exigir um servidor local e uma URL cadastrada no Supabase. Se tiver Python instalado, abra o terminal dentro da pasta do projeto e execute:

```bash
python -m http.server 8000
```

Acesse `http://localhost:8000` no navegador e inclua essa URL em **Authentication → URL Configuration → Redirect URLs** do Supabase. Para encerrar o servidor, volte ao terminal e pressione `Ctrl+C`.

## Parte 4 — Publicar pelo GitHub Pages

### Criar o repositório

1. Entre em [github.com](https://github.com/) e crie um repositório novo. Para deixar o código mais reservado, escolha privado (verifique se o seu tipo de conta permite Pages em repositórios privados) ou público.
2. Envie os itens da pasta do projeto para a **raiz** do repositório: `index.html`, `styles.css`, `app.js`, `config.js`, `README.md`, `TUTORIAL.md` e a pasta `supabase/`. Não envie arquivos de exemplo de segredos; este projeto não inclui chave secreta.
   - No site do GitHub, use **Add file → Upload files**, selecione os itens e confirme em **Commit changes**.
   - Alternativamente, com Git instalado, abra um terminal na pasta e rode:

```bash
git init
git add .
git commit -m "Publica Gold Ledger"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git
git push -u origin main
```

### Ativar Pages

3. No repositório, abra **Settings → Pages**.
4. Em **Build and deployment**, selecione **Deploy from a branch**; escolha `main` e a pasta `/ (root)`; clique **Save**.
5. Aguarde a publicação. O endereço costuma seguir o padrão `https://SEU-USUARIO.github.io/SEU-REPOSITORIO/`. O GitHub mostra a URL exata na mesma página de Pages.
6. Volte ao Supabase e confirme que a URL publicada está em **Authentication → URL Configuration → Site URL** e **Redirect URLs**. Ajuste conforme o endereço real e salve.
7. Acesse o site publicado, crie sua conta e, se necessário, confirme o e-mail. Faça o primeiro lançamento e defina uma meta.

> **Atenção ao código público:** qualquer chave escrita no `config.js` será visível a quem abrir o repositório ou o site. Isso é esperado para a chave pública Supabase. Nunca inclua senha do banco, chave `service_role` ou credenciais privadas. RLS deve permanecer ativado nas tabelas.

## Usar o painel

- **Saldo:** registre o total disponível no banco. Exemplos aceitos: `500`, `1k`, `10k`, `1kk`, `1,25kk`, `1kkk` e `250 gp`. Para números decimais, a vírgula ou ponto são aceitos.
- **Data:** vem preenchida com o dia atual e pode ser corrigida. Há no máximo um lançamento por data; edite o registro existente se precisar corrigi-lo.
- **Farm ou redução:** o painel compara registros consecutivos. Se o saldo diminuir, mostra a redução em vez de contar como gold farmado.
- **Meta:** cadastre o saldo final desejado. O progresso é uma porcentagem discreta; a estimativa usa a variação líquida entre o registro mais antigo e o mais recente, dividida pelos dias transcorridos. Com menos de dois dias distintos, ou sem avanço líquido, a previsão não é exibida.
- **Linha do tempo:** mostra a data de início da meta, os dias com registro dentro do intervalo e a previsão quando há base para estimá-la. A data prevista é uma estimativa simples, não uma garantia.
- **Próxima meta:** ao lançar saldo que alcance uma meta, ela é marcada como concluída. Em seguida, use **Nova meta** para iniciar a próxima etapa.

## Privacidade e cuidados

- As tabelas têm Row Level Security (RLS) e cada política compara `auth.uid()` com o dono do registro.
- A chave pública pode ficar no front-end; a chave administrativa `service_role`/`secret` não pode.
- Use senha única e ative verificação por e-mail se possível. Mantenha o script SQL e as políticas sem desativar RLS.
- A aplicação carrega fontes e o cliente Supabase por serviços externos (Google Fonts e jsDelivr), portanto esses recursos e a conexão ao banco dependem de internet.
- Não há backup integrado: os dados residem no Supabase. Consulte as opções de backup do seu projeto Supabase para necessidades de recuperação.

## Solução de problemas

- **“Configure o Supabase”:** revise `config.js`, confirme a URL completa `https://...supabase.co` e a chave pública correta; depois atualize o site publicado.
- **Não consigo cadastrar/entrar:** veja a mensagem na tela e confira se o provedor Email está habilitado e se a confirmação de e-mail foi concluída.
- **Erro ao carregar/salvar:** confirme que executou `supabase/schema.sql`, que RLS está habilitado e que copiou o projeto e a chave correspondentes.
- **Página não atualiza depois do envio:** confira se o deploy do GitHub Pages terminou e faça uma atualização forçada do navegador.
- **URL incorreta/redirect:** compare o endereço do site com os valores de **Site URL** e **Redirect URLs** em Authentication.
