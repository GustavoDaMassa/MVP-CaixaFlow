class Customer < ApplicationRecord
  has_many :orders, dependent: :nullify

  validates :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[name phone email address created_at]
  end
end
