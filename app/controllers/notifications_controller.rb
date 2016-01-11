class NotificationsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' || c.request.format == 'application/xml'}

  def confirm_payment
    transaction = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode])
    if transaction.errors.empty?
      user = User.where(email: transaction.sender.email).first
      user.payment_status = "Pago"
      user.paid_on = DateTime.now
      user.save
    end
  end
end