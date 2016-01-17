class Crew::AdminsMethodsController < ApplicationController
  # before_action :authenticate_crew_admin!

  # PATCH
  # Change users position by changig their lots value
  def change_users
    user_1 = User.find(params[:user_id])
    user_2 = User.where(email: params[:user_2_email]).first

    if user_1.change_position_with user_2
      redirect_to :back, notice: "Usuários alternados com sucesso."
    else
      redirect_to :back, alert: "Não foi possível trocar os usuários."
    end
  end

  # PATCH
  # Disqualify user and puta waiting_list instead
  def disqualify_user
    user = User.find(params[:id])

    if !user.nil?
      user.disqualify
      redirect_to :back, notice: "Usuário desqualificado."
    else
      redirect_to :back, alert: "Não foi possível desqualificar."
    end
  end

  def change_payment_method
    payment = Payment.find(params[:id])
    method = params[:method]
    portions = params[:portions].to_i
    
    payment.change_method method, portions

    if payment.save
      redirect_to :back, notice: "Método do pagamento foi alterado."
    else
      redirect_to :back, alert: "Não foi possível alterar nétodo de pagamento"
    end
  end

end
