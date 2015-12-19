class Crew::AdminsController < ApplicationController
  before_action :authenticate_crew_admin!

  def dashboard
    respond_to do |format|
      format.html
      format.json { render json: current_admin }
    end
  end

  def index
    @admins = Crew::Admin.all

    respond_to do |format|
      format.html
      format.json { render json: @admins }
    end
  end

  def users
    @users = User.all

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end
end
