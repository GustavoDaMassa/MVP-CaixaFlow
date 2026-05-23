class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0, null: false
      t.decimal :total, precision: 10, scale: 2, default: 0, null: false
      t.text :notes
      t.datetime :scheduled_for
      t.references :user, null: false, foreign_key: true
      t.references :customer, null: true, foreign_key: true

      t.timestamps
    end
  end
end
