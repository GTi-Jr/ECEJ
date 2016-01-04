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
    # Directs /admin/products/* to Admin::ProductsController
    # (app/controllers/admin/products_controller.rb)
    get '/index' => 'admins#index'
    get '/dashboard' => 'admins#dashboard'
    get '/new_admin' => 'admins#new_admin'
    post '/create_admin' => 'admins#create_admin'
    devise_for :admins, class_name: "Crew::Admin"
  end

  #devise_for :users
  devise_for :users,
  controllers: {sessions: "users/sessions", passwords: "users/passwords", registrations: "users/registrations", confirmations: 'users/confirmations'},
  path: "/",
  path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'inscription', sign_up: 'new' },
  :skip => 'registration'

  devise_scope :user do
    get '/inscription/cancel' => 'users/registrations#cancel', :as => 'cancel_user_registration'

    get '/inscription/new' => 'users/registrations#new', :as => 'new_user_registration'
    post '/inscription' => 'users/registrations#create', :as => 'user_registration'

    get '/inscription/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put '/inscription' => 'users/registrations#update'

    delete '/inscription' => 'users/registrations#destroy'
  end
  resources :after_registration

  post "payment" => "checkout#create", :as => "payment"
  get "payment" => "checkout#new"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
