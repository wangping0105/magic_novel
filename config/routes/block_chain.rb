namespace :block_chain do
  resources :homes do
    collection do
      get :trade
    end
  end
end