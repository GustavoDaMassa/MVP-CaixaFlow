class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :ncm, format: { with: /\A\d{4}\.\d{2}\.\d{2}\z/, message: "deve estar no formato 0000.00.00" }, allow_blank: true

  def ncm_efetivo
    ncm.presence || category&.ncm
  end

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
