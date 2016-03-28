class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  #If you have extra params to permit, append them to the sanitizer.
  def verify_register_conclusion
    if !@user.is_completed?
      flash[:notice] = "Conclua sua inscrição para acessar todas as funções do sistema"
    	redirect_to cadastro_completar_path
    end
  end
  helper_method :check_and_redirect

  def get_current_lot
    @current_lot = Lot.active_lot
  end

  def get_user
  	@user = current_user
  end

  def determine_layout
    current_user.nil? ? "login" : "dashboard"
  end

  def user_must_have_paid
    if current_user.payment.nil? || !current_user.payment.partially_paid
      redirect_to authenticated_user_root_path, alert: "Por favor, efetue o pagamento."
    end
  end

end
