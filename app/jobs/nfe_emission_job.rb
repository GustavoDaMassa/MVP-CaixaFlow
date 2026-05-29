class NfeEmissionJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)
    NfeEmissionService.call(order)
  rescue NfeEmissionService::EmissionError => e
    Rails.logger.error("[NfeEmissionJob] order=#{order_id} error=#{e.message}")
    raise
  end
end
