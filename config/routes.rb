Rails.application.routes.draw do
  mount RuCaptcha::Engine => "/rucaptcha"
  root to: "homes#index"

  resources :sessions do
    collection do
      get :signout
      post :sign_up
    end
  end
  resources :users do
    collection do
      get :user_settings
    end
  end
  resources :books do
    member do
      get :collection, :uncollection
    end
    collection do
      get :csv_export
    end

    resources :book_chapters, path: :chapters do
      collection do
        get :get_chapter
      end
      member do
        get :big_show, :turn_js_show, :book_marks
      end
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
