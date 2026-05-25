class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  before_create :set_defaults

  def self.ransackable_attributes(_auth_object = nil)
    %w[name description price active category_id created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category]
  end

  private

  def set_defaults
    self.active = true if active.nil?
  end
end
