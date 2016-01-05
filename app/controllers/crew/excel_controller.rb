class Crew::ExcelController < ApplicationController
  before_action :authenticate_crew_admin!
  def users
    @users = User.all.order(:name)

    send_data @users.to_csv, filename: "Lista de congressistas.csv"    
  end

end
