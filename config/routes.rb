Rails.application.routes.draw do
  # Admin routes
  namespace :admin do
    root "dashboard#index"
    get 'show_admin_users', to: 'users#show_admin_users', as: 'show_admin_users'
    resources :users
    resources :roles
  end

  # Authentication
  resources :users, only: [:new, :create]

  get "/login",  to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # Password reset
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Profile
  resource :profile, only: [:show, :edit, :update], controller: 'profiles'

  # Home
  root "home#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
