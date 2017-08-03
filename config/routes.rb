Rails.application.routes.draw do
  resources :nodes, only: [:show, :index] do
    collection do
      get 'user_agents', to: 'nodes#user_agents'
      get 'countries', to: 'nodes#countries'
      get 'coordinates', to: 'nodes#coordinates'
      post 'join', to: 'nodes#join'
    end

    member do
      get 'latency', to: 'nodes#latency'
    end
  end

  get 'nodes/*host/port/*port', to: 'nodes#by_host_and_port'
  post 'nodes/*host/port/*port', to: 'nodes#join'
  get 'search', to: 'search#search'

  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
