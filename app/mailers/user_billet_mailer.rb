class UserBilletMailer < ApplicationMailer
  def send_billet_links(user)
    @user = user
    @payment = user.payment
    
    mail to: user.email, subject: "ECEJ 2016 - Link do(s) boleto(s)"
  end
end
