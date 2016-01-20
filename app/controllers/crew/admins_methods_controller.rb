class Crew::AdminsMethodsController < ApplicationController
  before_action :authenticate_crew_admin!

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

  def change_payment_status
    payment = Payment.find(params[:id])
    status = params[:status]
    payment.change_status status
    redirect_to :back, notice: "O status do pagamento de #{payment.user.email} foi alterado."
  end

  def change_payment_method
    payment = Payment.find(params[:id])
    method = params[:method]
    portions = params[:portions].to_i

    payment.change_method method, portions

    if payment.save
      redirect_to :back, notice: "Método do pagamento de #{payment.user.email} foi alterado."
    else
      redirect_to :back, alert: "Não foi possível alterar o método de pagamento"
    end
  end

  def move_user_to_lot
    lot = Lot.find(params[:lot_id])
    user = User.find(params[:user_id])

    if user.update_attribute :lot_id, lot.id
      redirect_to :back, notice: "Usuário foi movido para o lote #{lot.number}"
    else
      redirect_to :back, alert: "Não foi possíve mover o usuário para o lote #{lot.number}."
    end
  end

  def billet_portion_paid
    payment = Payment.find(params[:id])
    portion_paid = params[:portion_paid].to_i

    if payment.set_billet_portion_paid portion_paid
      redirect_to :back, notice: "A parcela #{portion_paid} foi paga."
    else
      redirect_to :back, alert: "Não foi possível alterar a parcela paga."
    end
  end

end
