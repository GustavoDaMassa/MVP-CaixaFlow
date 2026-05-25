class DashboardStats
  def orders_today_by_status
    Order.where(created_at: Date.current.all_day).group(:status).count
  end

  def revenue_today
    Order.where(created_at: Date.current.all_day, status: :delivered).sum(:total)
  end

  def revenue_this_week
    Order.where(created_at: Time.current.all_week, status: :delivered).sum(:total)
  end

  def low_stock_products
    Product.where(active: true).select(&:low_stock?)
  end

  def recent_orders
    Order.includes(:customer, :user).order(created_at: :desc).limit(5)
  end
end
