class AddNcmToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :ncm, :string
  end
end
