Rails.application.routes.draw do

  authenticated :admin do
    root 'crew/admins#dashboard',  as: :admin_root
    # Rails 4 users must specify the 'as' option to give it a unique name
    # root :to => "main#dashboard", :as => "authenticated_root"
  end
  authenticated :user do
    root 'user_dashboard#index',  as: :user_root
    # Rails 4 users must specify the 'as' option to give it a unique name
    # root :to => "main#dashboard", :as => "authenticated_root"
  end
  unauthenticated do
    root 'home#index'
  end

  namespace :crew do
    get '/index' => 'admins#index'
    get '/dashboard' => 'admins#dashboard'
    get '/new_admin' => 'admins#new_admin'

    get '/users/index' => 'users#index', as: :users_index
    get '/users/show/:id' => 'users#show', as: :user_show
    get '/users/new' => 'users#new', as: :user_new
    get '/users/edit/:id' => 'users#edit', as: :user_edit
    get '/users/qualified' => 'users#qualified', as: :users_qualified
    get '/users/disqualified' => 'users#disqualified', as: :users_disqualified
    get '/users/waiting_list' => 'users#waiting_list', as: :users_waiting_list

    resources :lots
    resources :rooms

    post '/create_admin' => 'admins#create_admin'
    devise_for :admins, class_name: "Crew::Admin"
  end

  #devise_for :users
  devise_for :users, controllers: {sessions: "users/sessions", registrations: "users/registrations"}, path: "/", path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'inscription', sign_up: 'new' }, :skip => 'registration'
  devise_scope :user do
    get '/inscription/cancel' => 'users/registrations#cancel', :as => 'cancel_user_registration'
    
    get '/inscription/new' => 'users/registrations#new', :as => 'new_user_registration'
    post '/inscription' => 'users/registrations#create', :as => 'user_registration'
    
    get '/inscription/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put '/inscription' => 'users/registrations#update'
   
    delete '/inscription' => 'users/registrations#destroy'
  end
  resources :after_registration

  # :id = lot.id
  # :auth = user.confirmation_token.first(9)
  patch '/registration/lot/:id/:auth' => 'lots#subscribe_into_lot', as: :subscribe_into_lot
end
