class UserMailer < ApplicationMailer
  def welcome(user, password)
    @user = user
    @password = password
    mail to: user.email, subject: "Bem vindo ao ALMEJ 2016!"
  end

  def quartos_antecipados(user)
    @user = user
    mail to: user.email, subject: "ALMEJ 2016 | Acesso antecipado aos quartos!"
  end
end
