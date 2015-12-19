class Crew::AdminsController < ApplicationController
  before_action :authenticate_admin!

  def dashboard
  end

  def index
    @admins = Crew::Admin.all
  end

  # O devise faz isso abaixo ########################################################

  def new
    @admin = Crew::Admin.new
  end

  def create
    if @admin.save
      redirect_to :dashboard
    else
      render :new
    end
  end

  def edit
  end

  def update
    if current_admin.update
      redirect_to root_path, notice: "Alterações realizadas com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @admin = Crew::Admin.where(email: params[:email])
  end
end
