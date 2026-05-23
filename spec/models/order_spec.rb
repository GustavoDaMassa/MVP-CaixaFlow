require "rails_helper"

RSpec.describe Order, type: :model do
  describe "validations" do
    it { should belong_to(:user) }
    it { should belong_to(:customer).optional }
    it { should have_many(:order_items).dependent(:destroy) }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values(pending: 0, preparing: 1, ready: 2, delivered: 3, cancelled: 4) }
  end

  describe "defaults" do
    it "defaults to pending status" do
      order = build(:order)
      expect(order).to be_pending
    end
  end

  describe "total via OrderTotalCalculator" do
    it "sums item subtotals" do
      order = create(:order)
      product = create(:product, price: 10.0)
      create(:order_item, order: order, product: product, quantity: 3, unit_price: 10.0)
      expect(OrderTotalCalculator.call(order)).to eq(30.0)
    end
  end
end
