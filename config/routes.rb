Rails.application.routes.draw do
  default_url_options :host => "smtp.mandrillapp.com"  
  get 'password_resets/create'

  get 'password_resets/edit'

  get 'password_resets/update'
  get 'index/welcome'

  resources :password_resets
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
     get 'recent_activity'
     get 'review_changes'
     post :import
     post :update_settings
     post 'commit_changes'
     post 'undo_all'
     post 'commit_all'
    end
    resources :guild_members do
      member do
        post 'change'
        post 'undo'
        post 'commit'
      end
      resources :items

    end
  end
  root 'index#welcome'
end
