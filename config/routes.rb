Rails.application.routes.draw do
  root to: "homes#index"
  get "login"=>"sessions#index"
  resources :sessions
  resources :users
end
