require "rails_helper"

RSpec.describe OrderReadyMailJob, type: :job do
  describe "#perform" do
    context "when order has customer with email" do
      it "enqueues a mail delivery" do
        customer = create(:customer, email: "cliente@test.com")
        order = create(:order, customer: customer, status: :ready)

        expect { OrderReadyMailJob.new.perform(order.id) }
          .to have_enqueued_mail(OrderMailer, :order_ready)
      end
    end

    context "when order has no customer" do
      it "does not enqueue mail" do
        order = create(:order, customer: nil, status: :ready)

        expect { OrderReadyMailJob.new.perform(order.id) }
          .not_to have_enqueued_mail
      end
    end

    context "when customer has no email" do
      it "does not enqueue mail" do
        customer = create(:customer, email: nil)
        order = create(:order, customer: customer, status: :ready)

        expect { OrderReadyMailJob.new.perform(order.id) }
          .not_to have_enqueued_mail
      end
    end
  end
end
