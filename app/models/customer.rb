class Customer < ApplicationRecord
  has_many :orders, dependent: :nullify, foreign_key: :customer_id

  validates :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[name phone email address created_at]
  end
end
