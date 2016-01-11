class Crew::PaymentsController < ApplicationController
  before_action :authenticate_crew_admin!
  before_action :load_user

  def set_user_payment
    status = params[:payment_status]

    case status
    when 'paid'
      @user.payment_status = "Pago"
    when 'waiting'
      @user.payment_status = "Em processamento"
    when 'cancelled'   
      @user.payment_status = "Não processado"
    when 'non_paid'
      @user.payment_status = "Não processado"   
    end

    if @user.save
      redirect_to :back, notice: "Status do pagamentoa foi alterado."
    else
      redirect_to :back, alert: "Não foi possível alterar o status do pagamento."
    end
  end

  private
    def load_user    
      @user = User.find(params[:id])
    end
end
