Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    root to: "dashboard#index"
    resources :users
  end

  resources :categories
  resources :customers, only: %i[index show new create edit update]
  resources :products
  resources :cash_registers, only: %i[index show new create] do
    member { patch :close }
  end

  resources :orders

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "orders#index"
end
