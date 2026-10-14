# Gold Ledger

Painel estático em HTML, CSS e JavaScript para acompanhar saldo de gold, variações diárias, metas e previsão de conclusão. Usa Supabase Auth e Postgres para sincronizar os dados por usuário; funciona em hospedagem estática, incluindo GitHub Pages.

## Comece aqui

1. Abra `TUTORIAL.md` e siga a configuração inicial do Supabase.
2. Preencha `config.js` com a URL do projeto e a chave **pública** (anon/publishable).
3. Publique a pasta na raiz de um repositório GitHub e habilite o GitHub Pages.

Não há build nem etapa de instalação. A aplicação carrega o cliente Supabase v2 pelo CDN; a conexão à internet é necessária. Consulte `supabase/schema.sql` para criar as tabelas e as políticas RLS.

## O que inclui

- Cadastro e acesso com e-mail/senha.
- Lançamentos de saldo em gp, k, kk e kkk, com data editável e um por dia.
- Variações, histórico editável/excluível, estimativa e meta ativa sequencial.
- Dados privados por usuário usando Row Level Security.

A chave `service_role` jamais deve ser colocada neste projeto. Um endpoint público pode ser baixado por qualquer visitante; use somente a chave pública do navegador.
