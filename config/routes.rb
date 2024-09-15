Rails.application.routes.draw do
  post "/users", to: "users#create"
  post "/auth/login", to: "auth#login"
end