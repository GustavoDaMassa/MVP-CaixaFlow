class OrderReadyMailJob < ApplicationJob
  queue_as :mailers

  def perform(order_id)
    order = Order.find(order_id)
    return unless order.customer&.email.present?

    OrderMailer.order_ready(order).deliver_later
  end
end
