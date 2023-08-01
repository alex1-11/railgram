class ThemesController < ApplicationController
  # GET /light_theme
  def light
    cookies.delete(:theme)
    redirect_to request.referrer || root_path
  end

  # GET /dark_theme
  def dark
    cookies[:theme] = 'dark'
    redirect_to request.referrer || root_path
  end
end
