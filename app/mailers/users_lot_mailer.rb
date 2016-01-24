class UsersLotMailer < ApplicationMailer
  def send_antecipated_lot(user, lot)
    @user = user
    @lot = lot
    mail to: user.email, subject: "ECEJ 2016 - Link de cadastro antecipado no #{lot.name}"
  end

  def allocated_on_third_lot(user)
    @user = user
    mail to: user.email, subject: "ECEJ 2016 - Você entrou para o #{lot.name}!"
  end

  def allocated(user)
    @user = user
    mail to: user.email, subject: "ECEJ 2016 - Você está no lote #{user.lot.number}"
  end

  def not_allocated(user)
    @user = user
    mail to: user.email, subject: "ECEJ 2016 - Fique atento a lista de espera!"
  end

  def choose_payment(user)
    @user = user
    mail to: user.email, subject: "ECEJ 2016 - Você pode nos dar uma mãozinha?"
  end

  def remember_lot_1_2_payment
    @user = user
    mail to: user.email, subject: "ECEJ 2016 - Você pode nos dar uma mãozinha?"
  end
end
