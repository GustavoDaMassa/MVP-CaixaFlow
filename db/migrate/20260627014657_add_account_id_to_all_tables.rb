class AddAccountIdToAllTables < ActiveRecord::Migration[8.0]
  TABLES = %i[
    users
    categories
    products
    customers
    orders
    cash_registers
    fiscal_configurations
    fiscal_documents
  ].freeze

  def up
    TABLES.each do |table|
      add_reference table, :account, null: true, foreign_key: true, index: true
    end

    default_account = execute(<<~SQL).first
      INSERT INTO accounts (name, subdomain, active, created_at, updated_at)
      VALUES ('Conta Padrão', 'default', true, NOW(), NOW())
      RETURNING id
    SQL

    account_id = default_account["id"]

    TABLES.each do |table|
      execute "UPDATE #{table} SET account_id = #{account_id} WHERE account_id IS NULL"
    end

    TABLES.each do |table|
      change_column_null table, :account_id, false
    end
  end

  def down
    TABLES.each do |table|
      remove_reference table, :account, index: true, foreign_key: true
    end
  end
end
