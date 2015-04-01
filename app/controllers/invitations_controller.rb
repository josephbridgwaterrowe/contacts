class InvitationsController < Devise::InvitationsController

  before_filter :configure_create_parameters, only: :create
  before_filter :configure_update_parameters, only: :update

  protected

  def configure_create_parameters
    # Override accepted parameters
    devise_parameter_sanitizer.for(:invite) do |u|
      u.permit(:email, :first_name, :last_name)
    end
  end

  def configure_update_parameters
    # Override accepted parameters
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:first_name,
               :last_name,
               :password,
               :password_confirmation,
               :invitation_token)
    end
  end
end
