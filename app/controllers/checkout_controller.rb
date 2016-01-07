class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :verify_register_conclusion
  before_action :check_payment_status

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
        cpf: @user.cpf,
        phone: {
          number: @user.phone
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

  private
  def set_payed
    @user.paid_on = Time.now
    @user.payment_status =  'Aguardando confirmação'
    @user.save
  end

  def  check_payment_status
    if @user.paid_on != nil
      flash[:success] = "Você já efetuou o pagamento, aguarde a confirmação de recebimento."
      redirect_to root_path
    end
  end
end
