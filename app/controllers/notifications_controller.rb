class NotificationsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' || c.request.format == 'application/xml'}

  def confirm_payment
    Rails.logger.info "NOTIFICAÇÃO RECEBIDA #{params[:transacaoID]}"
    transaction = PagSeguro::Transaction.find_by_code(params[:transacaoID])
    Rails.logger.info "\n\n NOTIFICAÇÃOTRANSAÇÃO \n  #{transaction}"
    if transaction.errors.empty?
      Rails.logger.info "\n\n\n TRANSAÇÃO ENCONTRADA"
      Rails.logger.info "\n\n  Enviada por #{transaction.sender.email}"
      Rails.logger.info "\n\n  Status: #{transaction.status}"
      user = User.where(email: transaction.sender.email).first
      case transaction.status.status
      when :initiated
        user.payment_status = "Em processamento"
      when :waiting_payment
        user.payment_status = "Em processamento"
      when :in_analysis
        user.payment_status = "Em processamento"
      when :paid
        user.payment_status = "Pago"
        user.paid_on ||= Datetime.now
      when :avaliable
        user.payment_status = "Pago"
        user.paid_on ||= DateTime.now
      when :in_dispute
      when :refunded
        user.payment_status = "Não processado"
        user.paid_on = nil
        user.lot = nil
      when :cancelled
        user.payment_status = "Não processado"
        user.paid_on = nil
        user.lot = nil
      when :chargeback_charged
        user.payment_status = "Não processado"
        user.paid_on = nil
        user.lot = nil
      when :contested
        user.payment_status = "Não processado"
      end
      user.save
    else
      Rails.logger.info "\n\n\n   Erros ao receber notificação:"
      transaction.errors.to_a.each do |error|
        Rails.logger.info "  - #{error}"
      end
    end
  end
end