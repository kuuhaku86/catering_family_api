Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/menus/owner', to: 'menus#index_owner'
  resources :menus, only: [:index]
  resources :categories, only: [:index]

  namespace :api do
    resources :categories
    resources :menus
    resources :orders
  end
end
