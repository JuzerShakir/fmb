Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "thaali_takhmeen#index"

  resource :sabeel do
    resources :thaali_takhmeen, except: [:index, :create]
  end

  post 'sabeel_thaali_takhmeen', to: 'thaali_takhmeen#create'
end
