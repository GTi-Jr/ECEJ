class Users::RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create]
before_filter :configure_account_update_params, only: [:update]
before_filter :get_current_lot
before_action :get_user
before_action :verify_register_conclusion, only: [:edit, :update, :edit_password, :update_password]

  layout :determine_layout
  #GET /user/sign_up
  def new
    super
  end

  #POST /user
  def create
      @user = User.new(inscription_params)
      @user.active = true
      @lot = Lot.first
      if(!@lot.nil? && !@lot.is_full?)
        @user.lot = @lot
      end
      if @user.save
        flash[:success] = "Inscrição realizada, em instantes receberá as instruções de confirmação"
        redirect_to root_path
      else
        flash[:error] = "Um erro ocorreu, não foi possível processar sua inscrição"
        redirect_to new_user_registration_path
      end
  end

  #GET /user/edit
  def edit
    super
  end

  #PUT /user
  def update
    cep = params[:postal_code]
    city = params[:city]
    complement = params[:complement]
    street = params[:street]
    @user.addres = "#{city}, #{cep}, #{street}, #{complement}"
    @user.completed = true
    if @user.save && @user.update_attributes(user_params)
      flash[:success] = "Cadastro atualizado."
      redirect_to root_path
    else
      flash[:error] = "Erro ao atualizar cadastro."
      redirect_to root_path
    end
  end

  def edit_password
  end

  def update_password
    if @user.valid_password?(params[:user][:current_password])
      if @user.update(password_params)
        # Sign in the user by passing validation in case their password changed
        sign_in @user, :bypass => true
        flash[:sucsses] = "Senha alterada com sucesso."
        redirect_to root_path
      else
        flash[:error] = "Não foi possível alterar sua senha."
        redirect_to password_edit_path
      end
    else
      flash[:error] = "Senha atual incorreta."
      redirect_to password_edit_path
    end
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
    devise_parameter_sanitizer.for(:account_update){ |u| u.permit(:name, :general_register, :birthday ,:cpf, :gender, :avatar, :phone, :special_needs, :addres ,:federation, :junior_enterprise, :job, :university) }
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

  def password_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:password, :password_confirmation)
  end

  def inscription_params
    params.require(:user).permit(:email,:password, :password_confirmation)
  end
  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:name, :general_register, :birthday ,:cpf, :gender, :avatar, :phone, :special_needs, :federation, :junior_enterprise, :job, :university)
  end
end
