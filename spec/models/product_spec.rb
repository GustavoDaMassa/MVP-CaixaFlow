require "rails_helper"

RSpec.describe Product, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should belong_to(:category) }
  end

  describe "associations" do
    it { should belong_to(:category) }
    # has_many :order_items validado no domínio Order
  end

  describe "defaults" do
    it "is active by default" do
      product = build(:product)
      expect(product.active).to be true
    end

  end

  describe "Category association" do
    it "Category has many products" do
      category = create(:category)
      product = create(:product, category: category)
      expect(category.products).to include(product)
    end

    # dependent: :destroy testado quando OrderItem existir (cascade chain)
  end
end
