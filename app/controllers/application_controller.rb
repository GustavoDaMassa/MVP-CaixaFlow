class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :set_tenant, unless: :devise_controller?
  layout :layout_by_resource

  private

  def set_tenant
    set_current_tenant(current_user.account) if current_user&.account
  end

  def layout_by_resource
    devise_controller? ? "devise" : "application"
  end

  def require_admin
    redirect_to root_path, alert: "Acesso restrito." unless current_user&.admin?
  end
end
