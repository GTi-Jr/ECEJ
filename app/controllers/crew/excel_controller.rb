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
    @users = @lot.all.order(:name)

    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv, filename: "Lista de congressistas no lote #{@lot.name}.csv" }
      format.xls
    end
  end

  def event_users_csv
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html
      format.csv { send_data @event.users.to_csv, filename: "Congressistas em #{@event.name}.csv" }
      format.xls
    end
  end
end
