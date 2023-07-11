Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root "home#index"

  resources :users, only: %i[show destroy] do
    resources :posts, only: :index
    member do
      get 'followers'
      get 'following'
    end
  end

  get 'settings', to: 'users#settings', as: 'user_settings'

  resources :posts, only: %i[show new create edit update destroy] do
    resources :comments, only: %i[index create destroy]
  end

  get 'feed', to: 'posts#feed', as: 'feed'
  get 'easter_egg', to: 'users#easter_egg', as: 'easter_egg'

  resources :likes, only: %i[create destroy]
  resources :relations, only: %i[create destroy]
end
