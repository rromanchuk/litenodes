Rails.application.routes.draw do
  resources :nodes, only: [:show, :index]
  root to: 'nodes#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
