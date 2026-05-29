class Customer < ApplicationRecord
  has_many :orders, dependent: :nullify, foreign_key: :customer_id

  validates :name, presence: true
  validates :cpf_cnpj, format: { with: /\A(\d{3}\.\d{3}\.\d{3}-\d{2}|\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2})\z/, message: "deve estar no formato CPF ou CNPJ" }, allow_blank: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[name phone email address cpf_cnpj created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[orders]
  end
end
