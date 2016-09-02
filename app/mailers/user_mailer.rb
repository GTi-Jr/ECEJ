class UserMailer < ApplicationMailer
  def welcome(user, password)
    @user = user
    @password = password
    mail to: user.email, subject: "Bem vindo ao ALMEJ 2016!"
  end
end
