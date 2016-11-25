Rails.application.routes.draw do
  mount RuCaptcha::Engine => "/rucaptcha"

  root to: "homes#index"
  get '/58countries'=> "homes#show"

  resource :homes do
    collection do
      get :tab_books, :react_demo
    end
  end
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
      put :commit_pending, :approve_pass, :approve_failure
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

  resources :managements
  resources :notifications do
    member do
      get :read
    end
  end

  namespace :user_home do
    resources :users
    # 主要的
    resources :books do
    end

    resources :authors
  end

  namespace :api do
    resource :homes do
      collection do
        get :talks
      end
    end
  end

end
