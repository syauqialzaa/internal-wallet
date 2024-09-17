Rails.application.routes.draw do
  post "/auth/login", to: "auth#login"
  delete "/auth/logout", to: "auth#logout"

  # resources :users, only: [:index, :show, :create, :update, :destroy] do
  #   member do
      # get "wallet", to: "users#show_wallet"
      # post "wallet/credit", to: "users#credit_wallet"
      # post "wallet/debit", to: "users#debit_wallet"
      # get "transactions", to: "users#show_transactions"
  #   end
  # end

  resources :users, only: [:create] do
    resource :stocks do
      post "invest"
      post "update_price"
    end
    resource :wallets, only: [:show] do
      post "top_up"     # POST /users/:user_id/wallet/credit (untuk top up ke wallet sendiri)
      post "send_wallet"
      resources :transactions, only: [:index] # GET /users/:user_id/wallet/transactions
    end
  end

  resources :teams, only: [:create] do
    resource :stocks do
      post "invest"
      post "update_price"
    end
    resource :wallets, only: [:show] do
      post "top_up"     # POST /users/:user_id/wallet/credit (untuk top up ke wallet sendiri)
      post "send_wallet"
      resources :transactions, only: [:index]
    end
  end

  resources :stocks, only: [:index]
end