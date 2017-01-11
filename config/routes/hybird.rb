namespace :hybird do
  root "home#index"
  resources :home do
	  collection do
	      get :tab_books
	    end
  end
end