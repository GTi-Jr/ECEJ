class UserDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :verify_register_conclusion

  layout "dashboard"
  
  def index
    case @user.payment.method
    when "PagSeguro"
      @method_message = "entrar novamente no PagSeguro."
    when "Boleto"
      @method_message = "receber um novo email com os boletos"
    when "Dinheiro"
      @method_message = "rever os dados da conta"      
    end
  end
end
