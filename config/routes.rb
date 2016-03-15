Rails.application.routes.draw do

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
    resources :hotels
    resources :rooms
    resources :events

    post '/create_admin' => 'admins#create_admin'
    devise_for :admins, class_name: "Crew::Admin", :skip => 'registration'

    devise_scope :admin do
      authenticated :admin do
        root 'crew/admins#dashboard',  as: :admin_root
      end
      unauthenticated do
        root to: "devise/sessions#new"
      end
    end

    get 'payments' => 'payments#index'

    # PDF
    get '/pdf/users' => 'pdfs#users', as: :download_users_pdf
    get '/pdf/event/:id' => 'pdfs#event_users', as: :download_event_users_pdf

    # Excel
    get 'excel/users' => 'excel#users', as: :download_users_excel
    get 'excel/event/users/:id' => 'excel#event_users', as: :download_event_users_excel
    get 'excel/lot/users/:id' => 'excel#lot_users', as: :download_lot_users_excel
    get 'excel/payments' => 'excel#payments', as: :download_payments_excel
    get 'excel/late_users' => 'excel#users_after_third_lot_expiration', as: :users_after_third_lot_expiration
    get 'excel/users/non_paid' => 'excel#non_paid_users', as: :download_non_paid_users_excel
    get 'excel/users/federation' => 'excel#users_federation', as: :download_users_federation
    get 'excel/current_payments' => 'excel#current_payments', as: :download_current_payments_excel

    # Admin methods
    patch 'change_users/:user_id/:user_2_email' => 'admins_methods#change_users', as: :change_users_position
    patch 'disqualify/:id' => 'admins_methods#disqualify_user', as: :disqualify_user
    patch 'change_payment_method/:id/:method/:portions' => 'admins_methods#change_payment_method', as: :change_payment_method
    patch 'change_payment_status/:id/:status' => 'admins_methods#change_payment_status', as: :change_payment_status
    patch 'set_billet_portion_paid/:id/:portion_paid' => 'admins_methods#billet_portion_paid', as: :set_billet_portion_paid
    patch 'move_user_to_lot/:user_id/:lot_id' => 'admins_methods#move_user_to_lot', as: :move_user_to_lot

  end

  #routes for :users
  devise_for :users,
  controllers: {sessions: "users/sessions", passwords: "users/passwords", registrations: "users/registrations", confirmations: 'users/confirmations'},
  path: "/",
  path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', unlock: 'unblock', registration: 'inscription', sign_up: 'new' },
  :skip => 'registration'

  devise_scope :user do
    authenticated :user do
      root to: 'user_dashboard#index',  as: :authenticated_user_root
    end
    unauthenticated :users do
      root to: "users/sessions#new", as: :unauthenticated_user_root
    end

    get '/inscription/cancel' => 'users/registrations#cancel', :as => 'cancel_user_registration'

    get '/inscription/new' => 'users/registrations#new', :as => 'new_user_registration'
    post '/inscription' => 'users/registrations#create', :as => 'user_registration'

    get '/inscription/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put '/inscription' => 'users/registrations#update'

    get '/senha/editar' => 'users/registrations#edit_password', :as => 'password_edit'
    put '/senha' => 'users/registrations#update_password'

    delete '/inscription' => 'users/registrations#destroy'
  end

  get "cadastro/completar" => "after_registration#edit"
  put "cadastro" => "after_registration#update"

  # post '/after_registration/:id' => 'after_registration#update'

  # routes for payment
  post 'confirm_payment' => 'notifications#confirm_payment', as: :confirm_payment
  post "payment" => "checkout#create", :as => "payment"
  get "payment" => "checkout#new"

  post 'payment_billet' => 'billets#billet', as: :payment_billet

  post 'payment_deposit' => 'checkout#deposit', as: :payment_deposit

  # get request so link can be sent through email
  # :id = lot.id
  # :auth = user.confirmation_token.first(8)
  get '/registration/lot/:id/:auth' => 'lots#subscribe_into_lot_early', as: :subscribe_into_lot_early
  patch '/registration/lot' => 'lots#subscribe_into_lot', as: :subscribe_into_lot

  # set payment manually
  patch '/user_payment/:id/:payment_status' => 'crew/payments#set_user_payment', as: :set_user_payment

  # Rooms routes
  get 'rooms/index' => 'rooms#index', as: :rooms
  patch 'room/:id/insert_current_user' => 'rooms#insert_user_into_room', as: :insert_user_into_room
  patch 'room/exit' => 'rooms#exit_room', as: :exit_room
end
