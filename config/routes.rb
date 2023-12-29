Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "thaalis#index"

  # * CUSTOM ROUTES
  # pages
  get "/home", to: "pages#home"
  # session
  get "/login", to: "sessions#new"
  post "/signup", to: "sessions#create"
  delete "/destroy", to: "sessions#destroy"

  # * RESOURCEFUL ROUTES
  resources :users

  resources :sabeels, shallow: true do
    resources :thaalis, except: %i[index] do
      resources :transactions, except: %i[index]
    end
  end

  namespace :sabeels, path: "sabeels/:apt" do
    get :active
    get :inactive
  end

  namespace :statistics do
    get :thaalis
    get :sabeels
  end

  namespace :thaalis, path: "thaalis/:year" do
    get :complete
    get :pending
    get :all
  end

  namespace :transactions do
    get :all, path: ""
  end

  # * ERRORS
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server", via: :all
end
