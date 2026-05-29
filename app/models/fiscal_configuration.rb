class FiscalConfiguration < ApplicationRecord
  enum :regime_tributario, {
    simples_nacional: 1,
    simples_nacional_excesso: 2,
    regime_normal: 3
  }

  validates :cnpj, presence: true, format: { with: /\A\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}\z/, message: "deve estar no formato 00.000.000/0000-00" }
  validates :razao_social, presence: true
  validates :regime_tributario, presence: true
  validates :uf, presence: true, length: { is: 2 }
  validates :municipio, :logradouro, :cep, presence: true
  validates :focus_nfe_token, presence: true
  validates :serie_nfe, :numero_atual_nfe, numericality: { only_integer: true, greater_than: 0 }

  def self.current
    first
  end
end
