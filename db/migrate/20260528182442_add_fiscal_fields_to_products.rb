class AddFiscalFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :ncm, :string
    add_column :products, :unidade, :string, default: "UN"
  end
end
