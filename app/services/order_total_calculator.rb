class OrderTotalCalculator
  def self.call(order)
    order.order_items.sum("quantity * unit_price")
  end
end
