class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :home_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def home_controller?
    params[:controller] == 'home'
  end

  protected

  def configure_permitted_parameters
    # Adds :name parameter from registration form to standart Devise set of params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # Allows to use params to change user password (https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-edit-their-password)
    update_attrs = %i[password password_confirmation current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end
end
