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
    get '/admin/:id/edit' => 'admins#edit'
    patch '/admin/:id' => 'admins#update'
    delete '/admins/:id' => 'admins#destroy'

    resources :users
    
    patch '/users/disqualify/:id' => 'users#disqualify', as: :user_disqualify
    patch '/users/requalify/:id' => 'users#requalify', as: :user_requalify
    get '/qualified_users' => 'users#qualified', as: :users_qualified
    get '/disqualified_users' => 'users#disqualified', as: :users_disqualified
    get '/waiting_list' => 'users#waiting_list', as: :users_waiting_list

    resources :lots
    resources :rooms
    resources :events

    post '/create_admin' => 'admins#create_admin'
    devise_for :admins, class_name: "Crew::Admin"

    get '/pdf/users' => 'pdfs#users', as: :download_users_pdf
    get '/pdf/event/:id' => 'pdfs#event_users', as: :download_event_users

    get 'excel/users' => 'excel#users', as: :download_users_excel
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
  # :auth = user.confirmation_token.first(8)
  patch '/registration/lot/:id/:auth' => 'lots#subscribe_into_lot', as: :subscribe_into_lot
end
