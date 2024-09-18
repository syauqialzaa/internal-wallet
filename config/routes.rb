Rails.application.routes.draw do
  post "/auth/login", to: "auth#login"
  delete "/auth/logout", to: "auth#logout"

  # user entity routes
  resources :users, only: [:create] do
    resource :stocks do
      post "invest"
      post "update_price"
    end
    resource :wallets, only: [:show] do
      post "top_up"
      post "send_wallet"
      resources :transactions, only: [:index]
    end
  end

  # team entity routes
  resources :teams, only: [:create] do
    resource :stocks do
      post "invest"
      post "update_price"
    end
    resource :wallets, only: [:show] do
      post "top_up"
      post "send_wallet"
      resources :transactions, only: [:index]
    end
  end

  # stock entity routes
  resources :stocks, only: [:index]

  # latest_stock_price library
  get "latest_stocks/V1/price_all", to: "latest_stocks#price_all"
end