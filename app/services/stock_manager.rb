class StockManager
  def self.decrement(order)
    order.order_items.each do |item|
      item.product.decrement!(:stock, item.quantity)
    end
  end

  def self.restore(order)
    order.order_items.each do |item|
      item.product.increment!(:stock, item.quantity)
    end
  end
end
