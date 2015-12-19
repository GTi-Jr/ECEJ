Rails.application.routes.draw do
   
  namespace :admin do
    # Directs /admin/products/* to Admin::ProductsController
    # (app/controllers/admin/products_controller.rb)
    devise_for :admins
  end

end
