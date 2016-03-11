class Crew::ExcelController < ApplicationController
  before_action :authenticate_crew_admin!
  def users
    @users = User.all.order(:name)

    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv, filename: "Lista de congressistas.csv" }
      format.xls
    end
  end

  def lot_users
    @lot = Lot.find(params[:id])
    @users = @lot.users.order(:name)

    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv, filename: "Lista de congressistas no lote #{@lot.name}.csv" }
      format.xls
    end
  end

  def event_users
    @event = Event.find(params[:id])
    @users = @event.users

    respond_to do |format|
      format.html
      format.csv { send_data @event.users.to_csv, filename: "Congressistas em #{@event.name}.csv" }
      format.xls
    end
  end

  def payments
    @payments = []
    @total = 0
    @date = Date.today
    users = User.select {|user| !user.payment.nil? }
    
    users.each do |user|
      payment = user.payment
      payment_data = {  name: user.name, 
                        method: payment.method,
                        portions: payment.portions,
                        portion_paid: payment.portion_paid,
                        amount_paid: payment.amount_paid }
      
      @total += payment_data[:amount_paid]
      @payments << payment_data              
    end

    respond_to do |format|
      format.xls
    end
  end

  def users_after_third_lot_expiration
    deadline = Lot.third.deadline_1
    @users = User.select { |user| user.created_at > deadline }
    
    respond_to do |format|
      format.xls
    end
  end

  def non_paid_users
    @users = User.select { |user| user.payment.nil? || !user.payment.partially_paid? }

    respond_to do |format|
      format.xls
    end
  end
end
