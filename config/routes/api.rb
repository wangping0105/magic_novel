namespace :api, defaults: { format: :json } do
  resources :activities do
    collection do
      get :record
    end
  end

	namespace :v1 do
		resources :auth, only: [] do
			collection do
				post :login, :logout, :code_login, :sign_up
				put :change_password
				get :ping, :send_verification_code
			end
		end

		resources :notifications
		resources :users do
      collection do
        get :my_books
      end
    end
		resources :versions do
			collection do
				get :lastest_version
			end
		end

		resources :attachments do
			collection do
				post :upload
			end
		end

		resources :home do
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
					get :big_show, :book_marks
				end
			end
			resources :book_volumes, path: :volumes do
			end
    end
	end
end