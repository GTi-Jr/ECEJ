class Users::RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create]
before_filter :configure_account_update_params, only: [:update]

layout 'login', :only => [:new]
layout 'dashboard', :only => [:edit]

  #GET /user/sign_up
  def new
    super
  end

  #POST /user
  def create
    super
  end

  #GET /user/edit
  def edit
    super
  end

  #PUT /user
  def update
    super
  end

  #DELETE /user
  def destroy
    super
  end

  #GET /user/cancel
  #Forces the session data which is usually expired after sign
  #in to be expired now. This is useful if the user wants to
  #cancel oauth signing in/up in the middle of the process,
  #removing all OAuth session data.
  def cancel
    super
  end

  protected

  #If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << :attribute
  end

  #If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update){ |u| u.permit(:avatar, :phone, :email,:password, :password_confirmation, :current_password) }
  end


  #The path used after sign up.
  def after_sign_up_path_for(user)
    edit_user_registration_path(user)
  end

  #The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(user)
    super(user)
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:avatar, :phone, :email,:password, :password_confirmation, :current_password)
  end
end
