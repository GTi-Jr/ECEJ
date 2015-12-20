Rails.application.routes.draw do
  root 'crew/admins#dashboard'
  
  namespace :crew do
    # Directs /admin/products/* to Admin::ProductsController
    # (app/controllers/admin/products_controller.rb)    
    get '/index' => 'admins#index'
    get '/dashboard' => 'admins#dashboard'
    get '/new_admin' => 'admins#new_admin'
    post '/create_admin' => 'admins#create_admin'
    devise_for :admins, class_name: "Crew::Admin"
  end
end
