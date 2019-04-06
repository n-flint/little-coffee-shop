Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  #merchant routes
  resources :items, only: [:index, :show]
  resources :merchants, only: [:index]
  get '/dashboard', to: 'merchants#dashboard', as: :dashboard

  #admin routes
  namespace :admin do
    get '/dashboard', to: 'users#show', as: :dashboard
    resources :merchants, only: [:show, :update]
    resources :users, only: [:show]
  end

  #user routes
  get '/cart', to: "cart#index", as: :cart
  get '/emptycart', to: "cart#destroy", as: :empty_cart
  get '/remove_item(/:id)', to: "cart#remove_item", as: :remove_item
  get '/increment_item(/:id)', to: "cart#increment_item", as: :increment_item
  get '/decrement_item(/:id)', to: "cart#decrement_item", as: :decrement_item
  get '/profile', to: "users#show", as: :profile
  get '/profile/edit', to: "users#edit", as: :edit_profile
  resources :cart, only: [:create]

  #all users routes
  get '/login', to: "sessions#new", as: :login
  post '/login', to: "sessions#create"
  get '/logout', to: "sessions#destroy", as: :logout

  resources :users, only: [:new, :create, :edit, :update]
end
