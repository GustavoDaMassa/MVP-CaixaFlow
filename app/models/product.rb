class Product < ApplicationRecord
  belongs_to :category
  # has_many :order_items adicionado no domínio Order

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :low_stock_threshold, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  before_create :set_defaults

  def low_stock?
    stock < low_stock_threshold
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name description price stock active category_id created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category]
  end

  private

  def set_defaults
    self.active = true if active.nil?
    self.stock ||= 0
    self.low_stock_threshold ||= 10
  end
end
