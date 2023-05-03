Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root "home#index"
  resources :users, only: %i[show destroy] do
    resources :posts, only: :index
  end

  resources :posts, only: %i[show new create edit update destroy]
  get 'settings', to: 'users#settings', as: 'user_settings'

  resources :likes, only: %i[create destroy]
end
