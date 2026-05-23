require "rails_helper"

RSpec.describe OrderItem, type: :model do
  describe "validations" do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0).only_integer }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
  end

  describe "#subtotal" do
    it "returns quantity * unit_price" do
      item = build(:order_item, quantity: 3, unit_price: 8.50)
      expect(item.subtotal).to eq(25.50)
    end
  end
end
