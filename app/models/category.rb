class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :ncm, format: { with: /\A\d{4}\.\d{2}\.\d{2}\z/, message: "deve estar no formato 0000.00.00" }, allow_blank: true
end
