# CaixaFlow — Erros e Correções

Registro de bugs identificados e corrigidos durante o desenvolvimento.

---

**2026-05-22 · Fase 4 · Faker::Name.full_name não existe**
- Erro: `I18n::MissingTranslationData: Translation missing: en.faker.name.full_name`
- Causa: `Faker::Name.full_name` não é um método válido da gem Faker
- Correção: substituir por `Faker::Name.name` na factory de User

---

**2026-05-22 · Fase 5 · allow_browser bloqueando request specs com 403**
- Erro: todos os request specs retornavam 403 Forbidden mesmo com RAILS_ENV=test
- Causa: `.env` exporta `RAILS_ENV=development`, que sobrescreve o `||=` do rails_helper; `allow_browser versions: :modern` é avaliado em tempo de carga com env=development e bloqueia o cliente de teste (sem User-Agent moderno)
- Correção: remover `allow_browser` do ApplicationController; rodar specs com `RAILS_ENV=test bundle exec rspec`

---

## Rails 8 Host Authorization bloqueia request specs com 403

**Indícios:** Todos os request specs retornavam 403 Forbidden mesmo para rotas públicas. O corpo da resposta continha "Blocked hosts: www.example.com".

**Diagnóstico:** O middleware `ActionDispatch::HostAuthorization` do Rails 8 bloqueia requisições cujo host não está na lista permitida. O host padrão usado por `ActionDispatch::TestRequest` é `www.example.com`, que não está na allowlist.

**Causa raiz:** Rails 8 ativa Host Authorization por padrão. Tentativas de corrigir via `config.hosts` no `test.rb` não surtiram efeito porque o middleware já estava inicializado antes de o arquivo ser processado.

**Solução:** Adicionado `config.before(:each, type: :request) { host! "localhost" }` no `rails_helper.rb`. O host `localhost` é sempre permitido pelo Rails 8.

**Commit:** `848d6c3`

**Lição:** No Rails 8, `config.hosts` precisa ser configurado antes da inicialização do middleware — o caminho confiável para specs é forçar `host! "localhost"` diretamente no `rails_helper.rb`.

---

## .env exportando RAILS_ENV=development fazia specs rodarem no ambiente errado

**Indícios:** Request specs retornavam 422 com `ActionController::InvalidAuthenticityToken` mesmo com `config.action_controller.allow_forgery_protection = false` no `test.rb`. Diagnóstico em runtime revelou `Rails.env == "development"` e `allow_forgery_protection == true` durante a execução dos specs.

**Diagnóstico:** O `rails_helper` usava `ENV['RAILS_ENV'] ||= 'test'`. O operador `||=` só atribui se a variável não existir — mas ao exportar o `.env` antes de rodar os specs (`export $(grep -v '^#' .env | xargs)`), a variável `RAILS_ENV=development` já estava definida no shell e vencia.

**Causa raiz:** O `.env` contém `RAILS_ENV=development` para uso no servidor local. Exportar todas as variáveis do `.env` antes do RSpec fazia a suite inteira rodar no ambiente de desenvolvimento — com CSRF ativo, `forgery_protection` habilitado e potencialmente usando o banco de desenvolvimento.

**Solução:** Alterado `ENV['RAILS_ENV'] ||= 'test'` para `ENV['RAILS_ENV'] = 'test'` no `rails_helper.rb`, forçando o ambiente de teste independente de variáveis de shell.

**Commit:** `0a9bb6d`

**Lição:** O `rails_helper` deve sempre forçar `RAILS_ENV=test` com `=` simples, nunca com `||=`. O `.env` de desenvolvimento não deve interferir na execução de specs.

---

## have_enqueued_mail falha sem queue_adapter :test configurado

**Indícios:** Todos os specs de job falhavam com `StandardError: To use HaveEnqueuedMail matcher set ActiveJob::Base.queue_adapter = :test`.

**Diagnóstico:** O matcher `have_enqueued_mail` exige que o adapter de fila do ActiveJob esteja configurado como `:test` para interceptar os enfileiramentos. Sem essa configuração, o matcher não consegue inspecionar a fila.

**Causa raiz:** O `rails_helper` não configurava o `queue_adapter` para specs do tipo `:job`.

**Solução:** Adicionado `config.before(:each, type: :job) { ActiveJob::Base.queue_adapter = :test }` no bloco `RSpec.configure` do `rails_helper.rb`.

**Commit:** `34e7696`

**Lição:** Specs de job e mailer com `have_enqueued_mail`/`have_enqueued_job` sempre requerem `queue_adapter :test`. Configurar por tipo (`:job`) no `rails_helper` evita esquecer em cada spec individual.

---
