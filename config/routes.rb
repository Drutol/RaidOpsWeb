Rails.application.routes.draw do
  get 'logs/create'

  resources :user_sessions
  resources :users do
    member do
      get 'activate'
    end
  end

  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout


  resources :guilds do
    member do
     get 'upload'
     get 'items_all'
     get 'download'
     post :import
    end
    resources :guild_members do
      resources :items
    end
  end
  root 'guilds#index'
end
