class BilletsController < CheckoutController
  def billet
    @user.payment ||= Payment.new do |payment|
      payment.method = "Boleto"
      payment.portions = params[:portions].to_i
      payment.set_payment
    end
    @user.payment_method ||= "Boleto"
    @user.payment_status = "Em processamento"
    unless @user.save
      redirect_to user_root_path, alert: "Não foi possível completar a ação"
    end

    UserBilletMailer.send_billet_links(@user).send_now

    redirect_to user_root_path, notice: "Enviamos um email para você contendo os links para gerar novos boletos."
  end

  # overrided method
  def check_payment_method
    unless @user.payment_method == nil || @user.payment_method == "boleto"
      redirect_to user_root_path, notice: "Você não tem acesso a esse método de pagamento."
    end
  end
end
