Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root "home#index"

  resources :users, except: :index do
    resources :posts
  end

end
