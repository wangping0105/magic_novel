Rails.application.routes.draw do
  mount RuCaptcha::Engine => "/rucaptcha"
  root to: "homes#index"

  resources :sessions do
    collection do
      get :signout
      post :sign_up
    end
  end
  resources :users
  # 主要的
  resources :posts do

  end

end
