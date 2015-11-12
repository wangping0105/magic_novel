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
  resources :books do

  end
  # 主要的
  resources :posts do

  end

  namespace :user_home do
    resources :users
    # 主要的
    resources :posts do

    end
  end

end
