class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  layout :layout_by_resource

  private

  def layout_by_resource
    devise_controller? ? "devise" : "application"
  end

  def require_admin
    redirect_to root_path, alert: "Acesso restrito." unless current_user&.admin?
  end
end
