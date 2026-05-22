class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!

  private

  def require_admin
    redirect_to root_path, alert: "Acesso restrito." unless current_user&.admin?
  end
end
