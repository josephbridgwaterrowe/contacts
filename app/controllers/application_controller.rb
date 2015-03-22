class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  check_authorization :unless => :devise_controller?
  rescue_from CanCan::AccessDenied, with: :render_403

  protect_from_forgery with: :exception

  def render_403
    respond_to do |format|
      format.html { render :template => 'errors/error_403', status: 403 }
      format.any { head :forbidden }
    end
    #true
  end
end
