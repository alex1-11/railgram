class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :home_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def home_controller?
    params[:controller] == 'home'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
