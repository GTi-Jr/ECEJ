class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  #GET /resource/sign_in
  def new
    super
  end

  #POST /resource/sign_in
  # Resolver verficação de cadastro completo
  def create
    if(current_user.user_is_completed)
      super
    else
      super
      edit_user_registration_path(current_user)
    end
  end

  #DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  #If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) << :attribute
  end
end
