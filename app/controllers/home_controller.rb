class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to user_url(@viewer)
    else
      render :index
    end
  end
end
