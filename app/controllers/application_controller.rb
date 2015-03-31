class ApplicationController < ActionController::Base
  # before_filter :redirect_to_sign_in_if_not_authenticated!, unless: :devise_controller?
  before_filter :authenticate_user!

  check_authorization :unless => :devise_controller?
  rescue_from CanCan::AccessDenied, with: :render_403

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # def redirect_to_sign_in_if_not_authenticated!
  #   redirect_to users_sign_in_path() unless current_user
  # end

  def render_403
    respond_to do |format|
      format.html { render :template => 'errors/error_403', status: 403 }
      format.any { head :forbidden }
    end
  end
end
