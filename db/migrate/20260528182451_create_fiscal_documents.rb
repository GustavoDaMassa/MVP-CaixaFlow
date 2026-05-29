class CreateFiscalDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :fiscal_documents do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :numero
      t.integer :serie
      t.string :chave_acesso
      t.integer :status, default: 0, null: false
      t.string :focus_ref
      t.string :protocolo
      t.text :motivo_rejeicao
      t.datetime :emitted_at
      t.string :danfe_url

      t.timestamps
    end
  end
end
