class BilletsController < CheckoutController
  def billet
    @lot = @user.lot
    @user.payment_method ||= "boleto"
    @user.payment_status = "Em processamento"
    unless @user.save
      redirect_to user_root_path, alert: "Não foi possível completar a ação"
    end

    if @user.federation.empty?
      redirect_to @lot.link_unfed
    else
      redirect_to @lot.link_fed
    end
  end

  # overrided method
  def check_payment_method
    unless @user.payment_method == nil || @user.payment_method == "billet"
      redirect_to user_root_path, notice: "Você não tem acesso a esse método de pagamento."
    end
  end
end
