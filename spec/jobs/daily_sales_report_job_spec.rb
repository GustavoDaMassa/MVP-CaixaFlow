require "rails_helper"

RSpec.describe DailySalesReportJob, type: :job do
  describe "#perform" do
    it "enqueues mail for each admin" do
      create(:user, :admin)
      create(:user, :admin)
      create(:user, role: :atendente)

      expect { DailySalesReportJob.new.perform }
        .to have_enqueued_mail(ReportMailer, :daily_sales_report).exactly(2).times
    end

    it "does not enqueue mail when there are no admins" do
      create(:user, role: :atendente)

      expect { DailySalesReportJob.new.perform }
        .not_to have_enqueued_mail
    end
  end
end
