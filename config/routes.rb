# config/routes.rb
Rails.application.routes.draw do
  root 'bank_accounts#index'
  
  resources :bank_accounts, only: [:index] do
    collection do
      post :calculate_investment
    end
  end
end