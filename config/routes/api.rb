namespace :api, defaults: { format: :json } do
	namespace :v1 do
		resources :auth, only: [] do
			collection do
				post :login, :logout, :code_login, :sign_up
				put :change_password
				get :ping, :send_verification_code
			end
		end

		resources :notifications
		resources :users
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
	end
end