Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "thaali_takhmeens#index"

  # * CUSTOM ROUTES
  # session
  get "/login", to: "sessions#new"
  post "/signup", to: "sessions#create"
  delete "/destroy", to: "sessions#destroy", as: :destroy_session

  # thaali-takhmeen
  get "/takhmeens/stats", to: "thaali_takhmeens#stats", as: :takhmeens_stats
  get "/takhmeens/:year/complete", to: "thaali_takhmeens#complete", as: :takhmeens_complete
  get "/takhmeens/:year/pending", to: "thaali_takhmeens#pending", as: :takhmeens_pending
  get "/takhmeens/:year/all", to: "thaali_takhmeens#all", as: :takhmeens_all

  # transactions
  get "/transactions", to: "transactions#index", as: :all_transactions

  # * RESOURCEFUL ROUTES
  resources :users

  resources :sabeels, shallow: true do
    get :stats, on: :collection

    resources :takhmeens, controller: "thaali_takhmeens", except: [:index] do
      resources :transactions, except: [:index]
    end
  end

  namespace :sabeels, path: "sabeels/:apt" do
    get :active
    get :inactive
  end

  # * ERRORS
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server", via: :all
end
