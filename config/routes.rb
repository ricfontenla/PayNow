Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  devise_for :admins

  namespace :admin do
    resources :payment_methods
    resources :companies, only: [:index, :show, :edit, :update] do
      put 'generate_token', on: :member
      resources :orders, only: [:index, :show, :edit, :update]
    end
  end

  namespace :user do
    resources :companies, only: [:show, :new, :create, :edit, :update], param: :token do
      put 'generate_token', on: :member
      get 'my_payment_methods', on: :member
      resources :payment_methods, only: [:index, :show] do
        resources :boleto_accounts, only: [:new, :create, :edit, :update, :destroy]
        resources :card_accounts, only: [:new, :create, :edit, :update, :destroy]
        resources :pix_accounts, only: [:new, :create, :edit, :update, :destroy]
      end
      resources :products
      resources :orders, only: [:index] do
        get 'last_90_days', on: :collection
        get 'all_orders', on: :collection
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :final_customers, only: [:create]
      resources :orders, only: [:index, :create, :update], param: :token
    end
  end

  resources :receipts, only: [:show], param: :token
end
