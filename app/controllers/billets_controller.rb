class BilletsController < CheckoutController
  def new
    @lot = @user.lot
    @user.payment_method ||= "billet"
    unless @user.save
      redirect_to user_root_path, alert: "Não foi possível completar a ação"
    end
  end

  # overrided method
  def check_payment_method
    unless @user.payment_method == nil || @user.payment_method == "billet"
      redirect_to user_root_path, notice: "Você não tem acesso a esse método de pagamento."
    end
  end
end
