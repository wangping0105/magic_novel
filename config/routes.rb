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
    member do
      get :collection, :uncollection
    end
    resources :book_chapters, path: :chapters do
      get :get_chapter, on: :collection
      get :big_show, on: :member
    end
    resources :book_volumes, path: :volumes do
    end
  end
  # 主要的
  resources :posts do

  end

  namespace :user_home do
    resources :users
    # 主要的
    resources :books do
    end

    resources :authors
  end

end
