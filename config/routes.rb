Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/menus/owner', to: 'menus#index_owner'
  resources :menus, only: [:index]
  resources :categories, only: [:index]
  get '/orders/revenue', to: 'orders#revenue'
  resources :orders, only: [:index]

  namespace :api do
    resources :categories
    resources :menus
    get '/orders/revenue', to: 'orders#index_revenue'
    resources :orders
  end
end
