class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :verify_register_conclusion

  layout "user_dashboard"

  def new
    #order(@user)
    if @total == 0
      redirect_to root_path, :alert => "Você ainda não tem itens para ser comprados"
    end
    if(@user.federation == nil)
      @total = 15
    else
      @total = 10
    end
    session[:price] = @total
    session[:description] = 'Teste'
  end

  def create
    payment = PagSeguro::PaymentRequest.new

    payment.reference = 'lote[id]user[id]'
    # payment.notification_url = notifications_url
    payment.redirect_url = 'localhost:3000/payment'

      payment.items << {
        id: 1,
        description: session[:description],
        amount: session[:price]
      }

      payment.sender = {
        name: @user.name,
        email: 'c14330875633327824357@sandbox.pagseguro.com.br',
        cpf: '06105889313',
        phone: {
          number: '88310483'
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
    end
  end

  protected
  #If you have extra params to permit, append them to the sanitizer.
  def verify_register_conclusion
    if !@user.is_completed?
      redirect_to after_registration_path(:personal_information)
    end
  end
  def get_user
    @user = current_user
  end

end
