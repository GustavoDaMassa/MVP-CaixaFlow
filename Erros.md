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
