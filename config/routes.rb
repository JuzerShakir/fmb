Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "thaali_takhmeens#index"

  # * CUSTOM ROUTES
  # sabeels
  get "/sabeels", to: "sabeels#index", as: :all_sabeels
  get "/sabeels/stats", to: "sabeels#stats", as: :sabeels_stats
  get "/sabeels/active/:apt", to: "sabeels#active", as: :sabeels_active
  get "/sabeels/total/:apt", to: "sabeels#total", as: :sabeels_total

  # thaali-takhmeen
  get "/takhmeens/stats", to: "thaali_takhmeens#stats", as: :takhmeens_stats
  get "/takhmeens/:year/complete", to: "thaali_takhmeens#complete", as: :takhmeens_complete
  get "/takhmeens/:year/pending", to: "thaali_takhmeens#pending", as: :takhmeens_pending
  get "/takhmeens/:year/all", to: "thaali_takhmeens#all", as: :takhmeens_all

  # transactions
  get "/transactions/all", to: "transactions#index", as: :all_transactions

  # * RESOURCEFUL ROUTES
  resources :sabeels, shallow: true, except: [:index]  do
    resources :takhmeens, controller: "thaali_takhmeens", except: [:index] do
      resources :transactions, except: [:index]
    end
  end
end