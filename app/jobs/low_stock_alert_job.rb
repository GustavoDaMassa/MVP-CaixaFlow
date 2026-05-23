class LowStockAlertJob < ApplicationJob
  queue_as :low

  def perform
    products = Product.all.select(&:low_stock?)
    return if products.empty?

    admins = User.where(role: :admin)
    admins.each { |admin| ReportMailer.low_stock_alert(admin, products).deliver_later }
  end
end
