class NotificationsController < ApplicationController
  protect_from_forgery with: :null_session
  
  def confirm_payment
    transaction = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode])
    if transaction.errors.empty?
      pagseg_notification = PagSeguroNotification.new
      pagseg_notification.log = transaction.to_yaml
      pagseg_notification.save
    end
  end
end