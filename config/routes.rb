Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "thaali_takhmeens#index"

  get "/transactions/all", to: "transactions#all", as: :transactions_all
  get "/sabeels/all", to: "sabeels#all", as: :all_sabeels

  resource :sabeel, shallow: true do
    resources :thaali_takhmeens, except: [:index] do
      resources :transactions, except: [:index, :new, :create]
    end
  end

  get "/thaali_takhmeens/:id/transactions/new", to: "transactions#new", as: :new_thaali_takhmeen_transaction
  post "/thaali_takhmeens/:id/transactions", to: "transactions#create", as: :thaali_takhmeen_transactions
end
