Rails.application.routes.draw do
  post 'api/get_status'
  post 'api/import'
  post 'api/download'

  default_url_options :host => "smtp.mandrillapp.com"  
  get 'password_resets/create'

  get 'password_resets/edit'

  get 'password_resets/update'
  get 'index/welcome'
  get 'index/about'
  get 'index/uploading'
  get 'index/credits'
  get 'index/changelog'
  get 'index/wiki'
  get 'index/search'
  get 'index/uploader'

  resources :password_resets
  resources :user_sessions
  resources :users do
    member do
      get 'activate'
    end
  end

  get 'login' => 'user_sessions#new', :as => :login
  #post 'logout' => 'user_sessions#destroy', :as => :logout
  post 'user_sessions/log_out'


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
     get 'api_keys'
     post 'api_keys/new' => 'guilds#api_key_new'
     post 'api_keys/rem' => 'guilds#api_key_rem'
     post 'add_ass'
     post 'reject_ass'
     post 'rem_ass'
     post 'set_main_settings'
     post 'set_ads_profile'
     get 'show_pins'
     get 'ad_profiles'
    end
    resources :guild_members do
      member do
        post 'change'
        post 'undo'
        post 'commit'
        post 'remove'
        post 'import_gear'
      end
      resources :items
      resources :alts do
        get 'items'
      end

    end
  end
  root 'index#welcome'
end
