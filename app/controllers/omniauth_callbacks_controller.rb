class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def western_milling_apps
    @user = User.find_for_oauth(request.env['omniauth.auth'], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Western Milling Apps"

      # Always remember the user
      remember_me(@user)

      sign_in_and_redirect @user, :event => :authentication
    else
      session['devise.auth_data'] = request.env['omniauth.auth']
      redirect_to users_sign_in_url
    end
  end

  def failure
    set_flash_message :alert, :failure, :kind => OmniAuth::Utils.camelize(failed_strategy.name), :reason => failure_message
    redirect_to users_sign_in_url
  end

  def failure_message
    exception = env['omniauth.error']
    error   = exception.code          if exception.respond_to?(:code)
    error ||= exception.error_reason  if exception.respond_to?(:error_reason)
    error ||= exception.error         if exception.respond_to?(:error)
    error ||= env['omniauth.error.type'].to_s
    error.to_s.humanize if error
  end
end
