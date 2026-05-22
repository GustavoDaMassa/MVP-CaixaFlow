# CaixaFlow — Requisitos

## Contexto

Sistema web para gestão de pamonharia (adaptável a qualquer comércio de alimentos).
Substitui controle manual de pedidos, clientes e estoque.

---

## Requisitos Funcionais

### Autenticação e usuários
- RF01 — Login/logout com Devise
- RF02 — Dois papéis: `admin` e `atendente`
- RF03 — Admin gerencia usuários (criar, editar papel, desativar)
- RF04 — Atendente não acessa dashboard financeiro nem tela de usuários
- RF05 — Atendente visualiza e gerencia apenas os próprios pedidos

### Produtos
- RF06 — CRUD de produtos (nome, descrição, preço, estoque, threshold, categoria, imagem)
- RF07 — CRUD de categorias
- RF08 — Busca e filtro por nome, categoria, faixa de preço e status de estoque (Ransack)
- RF09 — Listagem paginada (Kaminari, 20 por página)

### Clientes
- RF10 — CRUD de clientes (nome, telefone, e-mail, endereço, observações)
- RF11 — Busca por nome, telefone ou e-mail (Ransack)
- RF12 — Listagem paginada (Kaminari, 25 por página)
- RF13 — Tela de show com histórico de pedidos do cliente

### Pedidos
- RF14 — Cliente é **opcional** no pedido (venda de balcão sem cadastro)
- RF15 — Criar pedido: selecionar cliente (opcional) + adicionar itens dinamicamente via JS
- RF16 — Total calculado em tempo real no formulário (JS)
- RF17 — Status: `pending → preparing → ready → delivered` (ou `cancelled`)
- RF18 — Filtro por status, período e cliente (Ransack)
- RF19 — Listagem paginada (Kaminari, 15 por página)
- RF20 — Estoque decrementado ao confirmar pedido; restaurado ao cancelar
- RF21 — `unit_price` do item é snapshot do preço no momento do pedido (não o preço atual)

### Dashboard (admin)
- RF22 — Contagem de pedidos do dia por status
- RF23 — Faturamento do dia e da semana
- RF24 — Lista de produtos com estoque abaixo do threshold
- RF25 — Últimos 5 pedidos

### Jobs assíncronos (Sidekiq)
- RF26 — `OrderReadyMailJob`: e-mail para o cliente quando status → `ready` (só se cliente tiver e-mail)
- RF27 — `DailySalesReportJob`: resumo diário às 18h para todos os admins (Sidekiq-cron)
- RF28 — `LowStockAlertJob`: alerta ao admin quando estoque cai abaixo do threshold

---

## Requisitos Não-Funcionais

- RNF01 — Testes com RSpec + FactoryBot (models, requests, jobs, services)
- RNF02 — Layout responsivo sem Bootstrap — CSS Grid e Flexbox puro
- RNF03 — JavaScript ES6+ vanilla (sem framework)
- RNF04 — Deploy via Docker + docker-compose no Home Server
- RNF05 — CI/CD: GitHub Actions → Docker Hub → Watchtower
- RNF06 — Redis obrigatório para Sidekiq
- RNF07 — Variáveis sensíveis via `.env` (nunca hardcoded)
- RNF08 — SOLID e DRY — lógica de negócio em Services, não em controllers

---

## Decisões de domínio

| Ponto | Decisão |
|---|---|
| Cliente no pedido | Opcional — venda de balcão não requer cadastro |
| E-mail de notificação | Disparado só se pedido tiver cliente com e-mail cadastrado |
| Cancelamento | Status `cancelled` — sem delete físico de pedidos |
| Pedidos de atendente | Cada atendente vê apenas os próprios pedidos |
| Threshold de estoque | Campo por produto (`low_stock_threshold`, default 10) |
| Preço no item | Snapshot no momento do pedido (`unit_price` em `order_items`) |
| Franquias / multi-unidade | Fora de escopo — sistema single-tenant |
