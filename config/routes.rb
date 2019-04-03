Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"
  resources :items, only: [:index, :show]
  # get "/merchants", to: merchants
  resources :merchants, only: [:index]
  get '/cart', to: "cart#index", as: :cart
  get '/login', to: "sessions#new", as: :login
  get '/logout', to: "sessions#destroy", as: :logout
  resources :users, only: [:new]

  get '/profile', to: "users#show", as: :profile


end
