Rails.application.routes.draw do
   
  devise_for :admins, class_name: "Crew::Admin"
  namespace :crew do
    # Directs /admin/products/* to Admin::ProductsController
    # (app/controllers/admin/products_controller.rb)
    end

end
