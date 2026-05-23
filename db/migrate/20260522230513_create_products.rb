class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.integer :stock, default: 0, null: false
      t.integer :low_stock_threshold, default: 10, null: false
      t.boolean :active, default: true, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
