class UsersLotMailer < ApplicationMailer
  def send_antecipated_lot(user, lot)
    @user = user
    @lot = lot

    mail to: user.email, subject: "ECEJ 2016 - Link de cadastro antecipado no #{lot.name}"
  end
end
