class Category < ApplicationRecord
  # has_many :products adicionado no domínio Product

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
