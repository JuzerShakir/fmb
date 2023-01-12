Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "thaali_takhmeens#index"

  # * CUSTOM ROUTES
  # sabeels
  get "/sabeels", to: "sabeels#index", as: :all_sabeels
  get "/sabeels/stats", to: "sabeels#stats", as: :sabeels_stats

  # transactions
  get "/transactions/all", to: "transactions#index", as: :all_transactions

  # * RESOURCEFUL ROUTES
  resources :sabeels, shallow: true, except: [:index]  do
    resources :takhmeens, controller: "thaali_takhmeens", except: [:index] do
      resources :transactions, except: [:index]
    end
  end
end