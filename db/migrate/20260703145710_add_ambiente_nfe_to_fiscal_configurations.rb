class AddAmbienteNfeToFiscalConfigurations < ActiveRecord::Migration[8.0]
  def change
    add_column :fiscal_configurations, :ambiente_nfe, :string, default: "homologacao", null: false
  end
end
