require "rails_helper"

RSpec.describe LowStockAlertJob, type: :job do
  describe "#perform" do
    it "enqueues mail when there are low stock products" do
      admin = create(:user, :admin)
      create(:product, :low_stock)

      expect { LowStockAlertJob.new.perform }
        .to have_enqueued_mail(ReportMailer, :low_stock_alert)
    end

    it "does not enqueue mail when no low stock products" do
      create(:user, :admin)
      create(:product, stock: 50, low_stock_threshold: 10)

      expect { LowStockAlertJob.new.perform }
        .not_to have_enqueued_mail
    end
  end
end
