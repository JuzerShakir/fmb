Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"

  # * CUSTOM ROUTES
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

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker
end
