class CheckoutNotifer < ApplicationMailer
  def send_payment_confirm(user)
    @user = user
    mail to: user.email, subject: "ECEJ 2016 - Recebemos seu pagamento"
  end
end
