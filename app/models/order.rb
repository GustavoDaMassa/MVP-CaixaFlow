class Order < ApplicationRecord
  belongs_to :user
  belongs_to :customer, optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum :payment_method, { cash: 0, pix: 1, debit_card: 2, credit_card: 3 }, default: :cash

  PAYMENT_LABELS = {
    "cash"        => "Dinheiro",
    "pix"         => "Pix",
    "debit_card"  => "Cartão Débito",
    "credit_card" => "Cartão Crédito"
  }.freeze

  accepts_nested_attributes_for :order_items, allow_destroy: true,
    reject_if: ->(attrs) { attrs["product_id"].blank? }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at scheduled_for customer_id user_id payment_method]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[customer user]
  end
end
