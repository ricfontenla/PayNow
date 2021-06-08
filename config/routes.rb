Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  devise_for :admins

  namespace :admin do
    resources :payment_methods
    resources :companies, only: [:index, :show, :edit, :update] do
      put 'generate_token', on: :member
    end
  end

  namespace :user do
    resources :companies, only: [:show, :new, :create], param: :token
  end
end
