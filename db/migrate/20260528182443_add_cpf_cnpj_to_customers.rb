class AddCpfCnpjToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_column :customers, :cpf_cnpj, :string
  end
end
