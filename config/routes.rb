Rails.application.routes.draw do
  # Admin routes
  namespace :admin do
    root "dashboard#index"
    resources :users
    resources :roles, only: [:index, :new, :create]
  end

  # Authentication
  resources :users, only: [:new, :create]

  get "/login",  to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # Password reset
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Home
  root "home#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
