Rails.application.routes.draw do
  root to: "homes#index"

  resources :sessions do
    collection do
      get :signout
    end
  end
  resources :users
  # 主要的
  resources :posts do

  end

end
