Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :menus, only: [:index]

  namespace :api do
    resources :categories
    resources :menus
    resources :orders
  end
end
