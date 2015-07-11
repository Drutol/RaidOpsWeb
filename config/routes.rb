Rails.application.routes.draw do
  default_url_options :host => "smtp.mandrillapp.com"  
  get 'password_resets/create'

  get 'password_resets/edit'

  get 'password_resets/update'
  get 'index/welcome'
  get 'index/about'
  get 'index/uploading'
  get 'index/credits'
  get 'index/changelog'

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
     get 'attendance'
     get 'raids'
     post :import
     post :update_settings
     post 'commit_changes'
     post 'undo_all'
     post 'commit_all'
     post 'assistant_apply'
     get 'ass_applications'
     get 'settings'
     post 'add_ass'
     post 'reject_ass'
     post 'rem_ass'
     post 'set_main_settings'
    end
    resources :guild_members do
      member do
        post 'change'
        post 'undo'
        post 'commit'
        post 'remove'
      end
      resources :items

    end
  end
  root 'index#welcome'
end
