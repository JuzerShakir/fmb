Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "thaali_takhmeens#index"

  resource :sabeel, shallow: true do
    resources :thaali_takhmeens, except: [:index] do
      resources :transactions, except: [:index]
    end
  end
end
