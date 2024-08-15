Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  namespace :api do
    namespace :v1 do
      resource :wallet, only: %i[show] do
        post :top_up
        post :transfer
        get :transactions
      end

      resource :portfolio, only: %i[show] do
        post :request_to_sell
        post :request_to_buy
        get :latest_transactions
      end

      get "/stocks/info/:symbol", to: "stocks#info"
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
