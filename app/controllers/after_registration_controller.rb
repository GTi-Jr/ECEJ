class AfterRegistrationController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :verify_register_conclusion

  layout "dashboard"

  def edit
    @user.completed = false
  end

  def update

    if !params[:user][:birthday].empty?
      birthday = params[:user][:birthday].split('-')
      birthday = Date.new(birthday[0].to_i, birthday[1].to_i, birthday[2].to_i)
      @user.birthday = birthday
    end
    cep = params[:postal_code]
    city = params[:city]
    complement = params[:complement]
    street = params[:street]
    @user.addres = "#{city}, #{cep}, #{street}, #{complement}"
    @user.completed = true
    if @user.save && @user.update_attributes(user_params)
      flash[:success] = "Cadastro completo, realize o pagamento para garantir sua vaga."
      redirect_to root_path
    else
      flash[:error] = "Não foi possível completar seu cadastro, verifique se seus dados estão corretos e entre em contato com nossa equipe."
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
    params.require(:user).permit(:name, :general_register, :cpf, :gender, :avatar, :phone, :special_needs, :federation, :junior_enterprise, :job, :university)
  end
end
