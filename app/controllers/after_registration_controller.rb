class AfterRegistrationController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  #before_action :verify_register_conclusion

  layout "dashboard"

  def edit
    @user.completed = false
  end

  def update
    if !params[:user][:birthday].empty?
      birthday = params[:user][:birthday].split('/')
      birthday = Date.new(birthday[2].to_i, birthday[1].to_i, birthday[0].to_i)
      @user.birthday = birthday
    end
    if @user.save && @user.update_attributes(user_params)
      @user.completed = true
      @user.save
      flash[:success] = "Cadastro completo, realize o pagamento para garantir sua vaga."
      redirect_to root_path
    else
      flash[:error] = "Não foi possível completar seu cadastro, verifique se seus dados estão corretos e entre em contato com nossa equipe."
      redirect_to root_path
    end
  end


  protected
  def verify_register_conclusion
    if @user.is_completed?
    	redirect_to root_path
    end
  end

  private
  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:name, :general_register, :cpf, :gender, :avatar, :phone, :special_needs, :addres,:federation, :junior_enterprise, :job, :university)
  end
end
