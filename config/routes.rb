class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end
Rails.application.routes.draw do
  draw :api
  draw :hybird

  # sidekiq
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'sidekiqadmin' && password == '5529d99a'
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  root to: "homes#index"
  get '/58countries'=> "homes#show"

  resource :homes do
    collection do
      get :tab_books, :react_demo, :uuid, :cache_demo
      post :create_payment
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
      get :collection, :uncollection, :settings
      put :commit_pending, :approve_pass, :approve_failure, :save_settings, :update_single_book
    end
    collection do
      get :csv_export
    end

    resources :book_chapters, path: :chapters do
      collection do
        get :get_chapter
      end
      member do
        get :big_show, :turn_js_show, :book_marks, :delete_behind
      end
    end
    resources :book_volumes, path: :volumes do
    end
  end

  resources :managements
  resources :request_logs
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
    resources :attachments
  end

  namespace :api do
    resource :homes do
      collection do
        get :talks
      end
    end

    resource :emoticons do
      collection do
        get :rand_show
      end
    end
  end
end
