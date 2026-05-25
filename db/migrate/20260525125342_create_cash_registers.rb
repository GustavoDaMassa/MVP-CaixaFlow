class CreateCashRegisters < ActiveRecord::Migration[8.0]
  def change
    create_table :cash_registers do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :opening_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :closing_amount, precision: 10, scale: 2
      t.datetime :opened_at, null: false
      t.datetime :closed_at
      t.text :notes

      t.timestamps
    end
  end
end
