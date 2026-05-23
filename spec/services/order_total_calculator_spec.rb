require "rails_helper"

RSpec.describe OrderTotalCalculator do
  describe ".call" do
    it "sums unit_price * quantity for all items" do
      order = create(:order)
      product1 = create(:product, price: 10.0)
      product2 = create(:product, price: 5.0)
      create(:order_item, order: order, product: product1, quantity: 2, unit_price: 10.0)
      create(:order_item, order: order, product: product2, quantity: 3, unit_price: 5.0)

      total = OrderTotalCalculator.call(order)
      expect(total).to eq(35.0)
    end

    it "returns 0 when order has no items" do
      order = create(:order)
      expect(OrderTotalCalculator.call(order)).to eq(0)
    end
  end
end
