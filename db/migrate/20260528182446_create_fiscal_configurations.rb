class CreateFiscalConfigurations < ActiveRecord::Migration[8.0]
  def change
    create_table :fiscal_configurations do |t|
      t.string :cnpj
      t.string :ie
      t.string :im
      t.string :razao_social
      t.string :nome_fantasia
      t.integer :regime_tributario
      t.string :logradouro
      t.string :numero
      t.string :complemento
      t.string :bairro
      t.string :municipio
      t.string :uf
      t.string :cep
      t.string :codigo_municipio
      t.string :cfop_padrao, default: "5102", null: false
      t.integer :serie_nfe, default: 1, null: false
      t.integer :numero_atual_nfe, default: 1, null: false
      t.string :focus_nfe_token

      t.timestamps
    end
  end
end
