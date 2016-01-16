class AfterRegistrationController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :verify_register_conclusion

  layout "dashboard"

  def edit
    @user.completed = false
  end

  def update
    cep = params[:postal_code]
    city = params[:city].capitalize
    complement = params[:complement]
    street = params[:street]
    @user.addres = "#{city}, #{cep}, #{street}, #{complement}"
    @user.completed = true
    @lot = Lot.first
    if(!@lot.nil? && !@lot.is_full? && @user.lot.nil?)
      @user.lot = @lot
    end

    if @user.save && @user.update_attributes(user_params)
      UsersLotMailer.not_allocated(@user).deliver_now if @user.lot.nil?

      flash[:success] = "Cadastro completo, realize o pagamento para garantir sua vaga."
      redirect_to root_path
    else
      flash[:error] = "Não foi possível completar seu cadastro, verifique se seus dados estão corretos e entre em contato com nossa equipe.\n #{@user.errors.full_messages}"
      redirect_to root_path
    end
  end

  private
  def verify_register_conclusion
    if @user.is_completed?
      redirect_to root_path
    end
  end

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:name, :general_register, :birthday ,:cpf, :gender, :avatar, :phone, :special_needs, :federation, :junior_enterprise, :job, :university)
  end
end
