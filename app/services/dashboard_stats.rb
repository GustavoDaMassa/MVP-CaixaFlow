class DashboardStats
  def revenue_today
    Order.where(created_at: Date.current.all_day).sum(:total)
  end

  def revenue_this_week
    Order.where(created_at: Time.current.all_week).sum(:total)
  end

  def recent_orders
    Order.includes(:customer, :user).order(created_at: :desc).limit(5)
  end
end
