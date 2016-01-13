class BilletsController < CheckoutController
  def billet
    Rails.logger.info "PARAMETRO #{params[:option]}\n"
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

    Rails.logger.info "\nportions = #{portions}\n"

    @user.payment ||= Payment.new do |payment|
      payment.method = "Boleto"
      payment.portions = portions
    end
    Rails.logger.info "\npayment.portions = #{@user.payment.portions}"

    @user.payment.set_payment

    unless @user.save
      redirect_to user_root_path, alert: "Não foi possível completar a ação. Tente novamente."
    end

    UserBilletMailer.send_billet_links(@user).send_now

    redirect_to user_root_path, notice: "Enviamos um email para você contendo os links para gerar novos boletos."
  end

  # overrided method
  def check_payment_method
    if @user.payment.method != nil && @user.payment.method != "Boleto"
      redirect_to user_root_path, notice: "Você não tem acesso a esse método de pagamento."
    end
  end
end
