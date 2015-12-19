Rails.application.routes.draw do
   
  
  namespace :crew do
    # Directs /admin/products/* to Admin::ProductsController
    # (app/controllers/admin/products_controller.rb)
    devise_for :admins, class_name: "Crew::Admin"
    get '/index' => 'admins#index'
    get '/dashboard' => 'admins#dashboard'
  end

end
