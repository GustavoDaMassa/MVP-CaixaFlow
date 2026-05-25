class OrderTotalCalculator
  def self.call(order)
    order.order_items
         .reject(&:marked_for_destruction?)
         .sum { |item| item.quantity.to_i * item.unit_price.to_d }
  end
end
