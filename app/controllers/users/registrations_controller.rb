class Users::RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create]
before_filter :configure_account_update_params, only: [:update]
before_filter :get_current_lot
before_action :verify_register_conclusion, only: [:edit, :update]

  layout :determine_layout
  #GET /user/sign_up
  def new
    super
  end

  #POST /user
  def create
      @user = User.new(inscription_params)
      @user.lot = @current_lot
      if @user.save
        flash[:success] = "Inscrição realizada, em instantes receberá as instruções de confirmação"
        redirect_to root_path
      else
        flash[:error] = "Email já cadastrado no sistema"
        redirect_to new_user_registration_path
      end
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
  def inscription_params
    params.require(:user).permit(:email,:password, :password_confirmation)
  end
  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:avatar, :phone, :email,:password, :password_confirmation, :current_password)
  end
end
