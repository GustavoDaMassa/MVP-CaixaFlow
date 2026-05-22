# CaixaFlow — Erros e Correções

Registro de bugs identificados e corrigidos durante o desenvolvimento.

---

**2026-05-22 · Fase 4 · Faker::Name.full_name não existe**
- Erro: `I18n::MissingTranslationData: Translation missing: en.faker.name.full_name`
- Causa: `Faker::Name.full_name` não é um método válido da gem Faker
- Correção: substituir por `Faker::Name.name` na factory de User

---
