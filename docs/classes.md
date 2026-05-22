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

<details id="user">
<summary><strong><a href="../app/models/user.rb">User</a> [Devise]</strong></summary>
<blockquote>

<details><summary>extends</summary>ApplicationRecord</details>
<details><summary>implements</summary>Devise — database_authenticatable, registerable, recoverable, rememberable, validatable</details>
<details><summary>atributos</summary>

- `name: string` — obrigatório
- `email: string` — obrigatório, único (Devise)
- `encrypted_password: string` (Devise)
- `role: integer` — enum `{ admin: 0, atendente: 1 }`, default: atendente
- `active: boolean` — default: true (via before_create)

</details>
<details><summary>metodos</summary>

- `admin?` — via enum Rails
- `atendente?` — via enum Rails
- `set_active_default` (private) — before_create

</details>

</blockquote>
</details>

<details id="category">
<summary><strong><a href="../app/models/category.rb">Category</a></strong></summary>
<blockquote>

<details><summary>extends</summary>ApplicationRecord</details>
<details><summary>atributos</summary>name: string (required, unique case-insensitive)</details>
<details><summary>dependencias</summary>has_many :products — adicionado no domínio Product</details>

</blockquote>
</details>

</blockquote>
</details>

<details id="dir-controllers">
<summary><strong>controllers/</strong></summary>
<blockquote>

<details id="application-controller">
<summary><strong><a href="../app/controllers/application_controller.rb">ApplicationController</a></strong></summary>
<blockquote>

<details><summary>extends</summary>ActionController::Base</details>
<details><summary>metodos</summary>

- `before_action :authenticate_user!` — Devise, global
- `require_admin` (private) — redireciona se não for admin

</details>

</blockquote>
</details>

<details id="dir-controllers-admin">
<summary><strong>admin/</strong></summary>
<blockquote>

<details id="admin-base-controller">
<summary><strong><a href="../app/controllers/admin/base_controller.rb">Admin::BaseController</a></strong></summary>
<blockquote>

<details><summary>extends</summary><a href="#application-controller">ApplicationController</a></details>
<details><summary>metodos</summary>

- `before_action :require_admin` — restringe acesso a admins

</details>

</blockquote>
</details>

</blockquote>
</details>

<details id="categories-controller">
<summary><strong><a href="../app/controllers/categories_controller.rb">CategoriesController</a></strong></summary>
<blockquote>

<details><summary>extends</summary><a href="#application-controller">ApplicationController</a></details>
<details><summary>metodos</summary>index, show, new, create, edit, update, destroy</details>
<details><summary>auth</summary>require_admin em new, create, edit, update, destroy — index e show para todos autenticados</details>

</blockquote>
</details>

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
