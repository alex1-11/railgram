Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root "home#index"
  resources :users, only: %i[show destroy] do
    resources :posts
  end

  get 'settings', to: 'users#settings', as: 'user_settings'
  resources :likes, only: %i[create destroy]
end
