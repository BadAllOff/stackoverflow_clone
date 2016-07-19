class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception unless Rails.env.test?

  before_filter :configure_permitted_parameters, if: :devise_controller?
  # check_authorization unless: :devise_controller?

  # gives ability to use flash helper methods
  add_flash_types :success, :error

  protected

  def configure_permitted_parameters
    # Fields for sign up
    devise_parameter_sanitizer.for(:sign_up) << :username
    # Fields for editing an existing account
    devise_parameter_sanitizer.for(:account_update) << :username
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, error: exception.message }
      format.js   { render nothing: true, error: exception.message }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end
end
