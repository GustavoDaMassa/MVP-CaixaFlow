# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_05_28_182451) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cash_registers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "opening_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "closing_amount", precision: 10, scale: 2
    t.datetime "opened_at", null: false
    t.datetime "closed_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cash_registers_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ncm"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cpf_cnpj"
  end

  create_table "fiscal_configurations", force: :cascade do |t|
    t.string "cnpj"
    t.string "ie"
    t.string "im"
    t.string "razao_social"
    t.string "nome_fantasia"
    t.integer "regime_tributario"
    t.string "logradouro"
    t.string "numero"
    t.string "complemento"
    t.string "bairro"
    t.string "municipio"
    t.string "uf"
    t.string "cep"
    t.string "codigo_municipio"
    t.string "cfop_padrao", default: "5102", null: false
    t.integer "serie_nfe", default: 1, null: false
    t.integer "numero_atual_nfe", default: 1, null: false
    t.string "focus_nfe_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fiscal_documents", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.integer "numero"
    t.integer "serie"
    t.string "chave_acesso"
    t.integer "status", default: 0, null: false
    t.string "focus_ref"
    t.string "protocolo"
    t.text "motivo_rejeicao"
    t.datetime "emitted_at"
    t.string "danfe_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_fiscal_documents_on_order_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.text "notes"
    t.datetime "scheduled_for"
    t.bigint "user_id", null: false
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_method", default: 0, null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.integer "stock", default: 0, null: false
    t.integer "low_stock_threshold", default: 10, null: false
    t.boolean "active", default: true, null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ncm"
    t.string "unidade", default: "UN"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.integer "role"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cash_registers", "users"
  add_foreign_key "fiscal_documents", "orders"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "categories"
end
