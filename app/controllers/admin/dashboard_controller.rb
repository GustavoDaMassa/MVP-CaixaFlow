module Admin
  class DashboardController < BaseController
    def index
      @stats = DashboardStats.new
    end
  end
end
