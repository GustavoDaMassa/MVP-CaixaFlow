class DailySalesReportJob < ApplicationJob
  queue_as :low

  def perform
    admins = User.where(role: :admin)
    admins.each { |admin| ReportMailer.daily_sales_report(admin).deliver_later }
  end
end
