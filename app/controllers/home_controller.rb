class HomeController < ApplicationController
  def index
    if user_signed_in?
      # TODO: 
      render :index
    end
  end
end
