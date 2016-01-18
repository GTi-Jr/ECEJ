class Users::PasswordsController < Devise::PasswordsController
  layout "login"
  #GET /resource/password/new
  def new
    super
  end

  #POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      flash[:notice] = "Enviamos um email com as informações para recuperação da senha"
      redirect_to unauthenticated_user_root_path
    else
      flash[:error] = "Não foi possível enviar as instruções de recuperação, verifique se o email está correto"
      redirect_to new_user_password_path
    end
  end

  #GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  #PUT /resource/password
  def update
    super
  end

  protected

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  #The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    super(resource_name)
  end
end
