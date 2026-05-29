Rails.application.routes.draw do
  devise_for :users, skip: :registrations

  namespace :admin do
    root to: "dashboard#index"
    resources :users
  end

  resources :categories
  resources :customers
  resources :products
  resources :cash_registers, only: %i[index show new create] do
    member { patch :close }
  end

  resources :orders do
    resource :fiscal_document, only: %i[show create] do
      member { post :check_status }
    end
  end

  resource :fiscal_configuration, only: %i[show edit update]

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "orders#index"
end
