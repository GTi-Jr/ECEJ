Rails.application.routes.draw do
   
  namespace :crew do
    # Directs /admin/products/* to Admin::ProductsController
    # (app/controllers/admin/products_controller.rb)
    devise_for :admins
  end

end
