class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end
Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Homeland::Engine => '/homeland'
  mount Sidekiq::Web => '/sidekiq'

  namespace :minings do
    root 'homes#index'
    resources :records
    resources :homes do
      collection do
        get :eosdice, :endless, :eosdicejacks
      end
    end
  end

  draw :api
  draw :hybird
  draw :block_chain

  root to: "homes#index"
  get '/58countries'=> "homes#show"

  resource :homes do
    collection do
      get :tab_books, :react_demo, :uuid, :cache_demo, :demo_page
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

  namespace :dapps do
    resources :eos_knights do
      collection do
        get :rank
      end
    end

    resources :eos_sanguos do
      collection do
        get :rank
        post :upload_file
      end
    end
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
end
