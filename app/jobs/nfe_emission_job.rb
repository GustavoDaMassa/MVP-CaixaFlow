class NfeEmissionJob < ApplicationJob
  queue_as :default

  def perform(order_id, account_id)
    account = Account.find(account_id)
    ActsAsTenant.with_tenant(account) do
      order = Order.find(order_id)
      NfeEmissionService.call(order)
    end
  rescue NfeEmissionService::EmissionError => e
    Rails.logger.error("[NfeEmissionJob] order=#{order_id} error=#{e.message}")
    raise
  end
end
