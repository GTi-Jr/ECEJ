module Crew::UsersHelper
  def load_payment user
    if !user.payment.nil?
      case user.payment.method
      when "Boleto"
        ["Não pago","Primeira parcela paga", "Segunda parcela paga", "Terceira parcela paga", "Pago"]
      when "PagSeguro"
        ["Pago","Não pago"]
      when "Dinheiro"
        ["Pago","Não pago"]
      end
    else
      "Usuário não pagou"
    end
  end
end
