class ReportMailer < ApplicationMailer
  def daily_sales_report(admin)
    @admin = admin
    @today = Date.current
    @orders = Order.where(created_at: @today.all_day)
    @revenue = @orders.sum(:total)
    mail(to: admin.email, subject: "Relatório de vendas — #{I18n.l(@today, format: :long)}")
  end
end
