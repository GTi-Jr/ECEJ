class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :redirect_if_user_has_paid
  before_action :verify_register_conclusion
  before_action :check_payment_status
  before_action :setup_lot

  layout "dashboard"

  def new
    @lot = @user.lot
    if(@user.federation == nil)
      @total = @lot.value_not_federated
    else
      @total = @lot.value_federated
    end
    session[:price] = @total
    session[:description] = @lot.name
    session[:lot] = @lot.number
  end

  def create
    @user.payment_method ||= "pagseguro"
    @user.save

    pagseguro_request
  end



  private
  def set_payed
    # @user.paid_on = DateTime.now
    @user.payment_status = 'Em processamento'
    @user.save
  end

  def setup_lot
    if @user.lot.nil?
      flash[:notice] = "Por enquanto, não temos vagas, aguarde a abertura de novas vagas."
      redirect_to root_path
    end
  end

  def check_payment_status
    if @user.payment_status != "Não processado"
      flash[:success] = "Você já solicitou o pagamento, aguarde a confirmação de recebimento."
    end
  end

  def check_payment_method
    unless @user.payment_method == nil || @user.payment_method == "pagseguro"
      flash[:error] = "Você não tem acesso a esse método de pagamento."
      redirect_to user_root_path
    end
  end

  def redirect_if_user_has_paid
    if @user.has_paid?
      # flash[:notice] = "Sua inscrição já foi paga!"
      redirect_to user_root_path, notice: "Sua inscrição já foi paga!"
    else
      get_payment if @user.payment_status == "Em processamento"
    end
  end

  def get_payment
    if controller_name != "create" && @user.payment_method == "pagseguro"
      pagseguro_request
    elsif controller_name != "billets" && @user.payment_method == "boleto"
      redirect_to payment_billet_path
    end
  end

  def pagseguro_request
    payment = PagSeguro::PaymentRequest.new

    payment.reference = "l#{session[:lot]}u#{@user.id}"
    payment.notification_url = 'localhost:3000/confirm_payment'
    payment.redirect_url = 'localhost:3000/payment'

      payment.items << {
        id: @user.id,
        description: session[:description],
        amount: session[:price]
      }

      payment.sender = {
        name: @user.name,
        email: @user.email,
        cpf: @user.cpf.numero.only_numbers,
        phone: {
          area_code: @user.phone.only_numbers[0..1],
          number: @user.phone.only_numbers[2..10]
        }
      }

    # Caso você precise passar parâmetros para a api que ainda não foram
    # mapeados na gem, você pode fazer de maneira dinâmica utilizando um
    # simples hash.
    # payment.extra_params << { paramName: 'paramValue' }
    # payment.extra_params << { senderBirthDate: '07/05/1981' }
    # payment.extra_params << { extraAmount: '-15.00' }

    response = payment.register

    # Caso o processo de checkout tenha dado errado, lança uma exceção.
    # Assim, um serviço de rastreamento de exceções ou até mesmo a gem
    # exception_notification poderá notificar sobre o ocorrido.
    #
    # Se estiver tudo certo, redireciona o comprador para o PagSeguro.
    if response.errors.any?
      raise response.errors.join("\n")
    else
      redirect_to response.url
      set_payed
    end
  end
end
