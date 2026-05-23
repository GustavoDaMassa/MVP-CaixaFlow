require "rails_helper"

RSpec.describe Product, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_numericality_of(:stock).is_greater_than_or_equal_to(0).only_integer }
    it { should validate_numericality_of(:low_stock_threshold).is_greater_than_or_equal_to(0).only_integer }
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

    it "has low_stock_threshold of 10 by default" do
      product = build(:product)
      expect(product.low_stock_threshold).to eq(10)
    end
  end

  describe "#low_stock?" do
    it "returns true when stock is below threshold" do
      product = build(:product, stock: 5, low_stock_threshold: 10)
      expect(product.low_stock?).to be true
    end

    it "returns false when stock is at or above threshold" do
      product = build(:product, stock: 10, low_stock_threshold: 10)
      expect(product.low_stock?).to be false
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
