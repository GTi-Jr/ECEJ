class BilletsController < CheckoutController
  def billet
    case params[:option]
    when "À vista"
      portions = 1
    when "Duas vezes"
      portions = 2
    when "Três vezes"
      portions = 3
    when "Quatro vezes"
      portions = 4
    else
      redirect_to user_root_path, alert: "Ocorreu um erro ao gerar seu(s) boleto(s). Tente novamente."
    end

    @user.payment ||= Payment.new do |payment|
      payment.method = "Boleto"
      payment.portions = portions
    end

    @user.payment.set_payment

    unless @user.save
      redirect_to user_root_path, alert: "Não foi possível completar a ação. Tente novamente."
    end

    if @user.payment.portions > 1
      message = "Os links dos boletos referentes as #{@user.payment.portions} parcelas da inscrição estão disponíveis na tela principal do sistema."
    else
      message = "O link do boleto referente a inscrição está disponível na tela principal do sistema."
    end

    redirect_to user_root_path, notice: message
  end

  # overrided method
  def check_payment_method
    if @user.payment.method != nil && @user.payment.method != "Boleto"
      redirect_to user_root_path, notice: "Você não tem acesso a esse método de pagamento."
    end
  end
end
