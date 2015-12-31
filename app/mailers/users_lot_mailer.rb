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
end
