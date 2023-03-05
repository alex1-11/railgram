class HomeController < ApplicationController
  def index
    if user_signed_in?
      # TODO: redirect_to 'posts#index'
    else
      render :index
    end
  end
end
