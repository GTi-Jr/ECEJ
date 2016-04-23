class UserDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :verify_register_conclusion

  layout "dashboard"

  def index
    @today = DateTime.now
    @payment = @user.payment
    @lot = @user.lot if !@user.lot.nil?
    @events_days = @user.events.event_days

    @deadlines = Array.new

    if !@lot.nil?
      @deadlines << @lot.deadline_1
      @deadlines << @lot.deadline_2
      @deadlines << @lot.deadline_3
      @deadlines << @lot.deadline_4
    end

    if !@payment.nil?
      case @user.payment.method
      when "PagSeguro"
        @method_message = "entrar novamente no PagSeguro."
      when "Boleto"
        @method_message = "receber um novo email com os boletos"
        @billets_links = @payment.billets_links
      when "Dinheiro"
        @method_message = "rever os dados da conta"
      end
    end
  end
end
