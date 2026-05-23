class ReportMailer < ApplicationMailer
  def low_stock_alert(admin, products)
    @admin = admin
    @products = products
    mail(to: admin.email, subject: "Alerta: produtos com estoque baixo")
  end

  def daily_sales_report(admin)
    @admin = admin
    @today = Date.current
    @orders = Order.where(created_at: @today.all_day)
    @revenue = @orders.where(status: :delivered).sum(:total)
    mail(to: admin.email, subject: "Relatório de vendas — #{I18n.l(@today, format: :long)}")
  end
end
