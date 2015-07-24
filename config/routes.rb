Rails.application.routes.draw do
  root to: "homes#index"

  resources :sessions
  resources :users
  # 主要的
  resources :posts do

  end

end
