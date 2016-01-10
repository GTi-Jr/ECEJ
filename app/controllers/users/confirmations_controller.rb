class Users::ConfirmationsController < Devise::ConfirmationsController
  layout "login"

  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      flash[:notice] = "As instruções foram enviadas com sucesso, verifique seu caixa de entrada"
    else
      flash[:notice] = "Um erro ocorreu ao enviar as informações, verifique se o email informado está correto"
    end
    redirect_to new_user_confirmation_path
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      flash[:notice] = "Sua conta foi confirmada con sucesso, entre agora mesmo em nosso sistema"
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end

  protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    super(resource_name)
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    super(resource_name, resource)
  end
end
