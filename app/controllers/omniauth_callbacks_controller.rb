class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :oauth

  def facebook

  end

  def twitter

  end

  private

  def oauth
    user = User.find_for_oauth(auth)
    if user && user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{action_name}".capitalize) if is_navigational_format?
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end
end