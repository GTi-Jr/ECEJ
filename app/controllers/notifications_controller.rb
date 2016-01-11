class NotificationsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' || c.request.format == 'application/xml'}

  def confirm_payment
    Rails.logger.info "NOTIFICAÇÃO RECEBIDA #{params[:notificationCode]}"
    transaction = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode])
    if transaction.errors.empty?
      Rails.logger.info " NOTIFICAÇÃO ENCONTRADA"
      Rails.logger.info "    Enviada por #{t.sender.email}"
      user = User.where(email: transaction.sender.email).first
      user.payment_status = "Pago"
      user.paid_on = DateTime.now
      user.save
    else
      Rails.logger.info "Erros ao receber notificação:"
      transaction.errors.to_a.each do |error|
        Rails.logger.info "  - #{error}"
      end
    end
  end
end