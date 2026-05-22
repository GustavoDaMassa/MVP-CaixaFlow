# CaixaFlow — Mapa de Classes

<details id="dir-root">
<summary><strong>caixaflow/ (raiz)</strong></summary>
<blockquote>

- [Gemfile](../Gemfile) — dependências do projeto
- [Gemfile.lock](../Gemfile.lock) — versões resolvidas
- [Rakefile](../Rakefile) — tasks Rake
- [docker-compose.yml](../docker-compose.yml) — dev: PostgreSQL + Redis
- [docker-compose.prod.yml](../docker-compose.prod.yml) — produção: app + db + redis + nginx + watchtower
- [Dockerfile](../Dockerfile) — imagem da aplicação
- [.env.example](../.env.example) — variáveis de ambiente necessárias
- [Erros.md](../Erros.md) — registro de bugs corrigidos

</blockquote>
</details>

<details id="dir-config">
<summary><strong>config/</strong></summary>
<blockquote>

- [routes.rb](../config/routes.rb) — devise_for, namespace admin, resources
- [database.yml](../config/database.yml) — PostgreSQL com variáveis de ambiente
- [sidekiq.yml](../config/sidekiq.yml) — concurrency e queues

<details id="dir-config-initializers">
<summary><strong>initializers/</strong></summary>
<blockquote>

- [sidekiq.rb](../config/initializers/sidekiq.rb) — redis url + cron job DailySalesReportJob

</blockquote>
</details>

</blockquote>
</details>

<details id="dir-app">
<summary><strong>app/</strong></summary>
<blockquote>

<details id="dir-models">
<summary><strong>models/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 conforme cada model for criado -->

</blockquote>
</details>

<details id="dir-controllers">
<summary><strong>controllers/</strong></summary>
<blockquote>

<details id="dir-controllers-admin">
<summary><strong>admin/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

<details id="dir-services">
<summary><strong>services/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

<details id="dir-jobs">
<summary><strong>jobs/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

<details id="dir-mailers">
<summary><strong>mailers/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

<details id="dir-javascript">
<summary><strong>javascript/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

</blockquote>
</details>

<details id="dir-spec">
<summary><strong>spec/</strong></summary>
<blockquote>

- [rails_helper.rb](../spec/rails_helper.rb) — FactoryBot, Devise helpers, Shoulda Matchers
- [spec_helper.rb](../spec/spec_helper.rb) — configuração base RSpec

<details id="dir-spec-factories">
<summary><strong>factories/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

<details id="dir-spec-models">
<summary><strong>models/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

<details id="dir-spec-requests">
<summary><strong>requests/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

<details id="dir-spec-jobs">
<summary><strong>jobs/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

<details id="dir-spec-services">
<summary><strong>services/</strong></summary>
<blockquote>

<!-- preenchido na Fase 5 -->

</blockquote>
</details>

</blockquote>
</details>

<details id="dir-docs">
<summary><strong>docs/</strong></summary>
<blockquote>

- [requisitos.md](requisitos.md) — requisitos funcionais e não-funcionais
- [arquitetura.md](arquitetura.md) — stack, modelo de dados, estrutura de pastas, rotas

</blockquote>
</details>
