Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "thaali_takhmeens#index"

  get "/transactions/all", to: "transactions#index", as: :all_transactions
  get "/sabeels", to: "sabeels#index", as: :all_sabeels

  resource :sabeel do
    resource :takhmeen, controller: "thaali_takhmeens", except: [:index] do
      resource :transaction, except: [:index]
    end
  end
end
