class Crew::AdminsController < ApplicationController
  layout 'admin_layout'
  before_action :authenticate_crew_admin!
  before_action :load_admin, only: [:edit, :update, :destroy]

  def dashboard
    # users
    @users = User.all
    @eligible_users = User.eligible.order(:created_at)
    @non_eligible_users = User.waiting_list
    @disqualified_users = User.disqualified
    @allocated_users = User.allocated
    # lots
    @lots = Lot.all
    @active_lot = Lot.active_lot
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

  def new_admin
    @admin = Crew::Admin.new
  end

  def create_admin
    @admin = Crew::Admin.new(admin_params)

    if @admin.save
      redirect_to admin_root_path, notice: "Admin criado com sucesso."
    else
      redirect_to crew_new_admin_path, alert: "Falha ao cadastrar novo admin."
    end
  end

  def destroy
    name = @admin.name
    if @admin.destroy
      redirect_to crew_index_path, notice: "O administrador #{name} foi excluído."
    else
      redirect_to crew_index_path, notice: "Não foi possível excluir o administrador #{name}."
    end
  end

  def edit
  end

  def update
    if @admin.update(admin_params)
      redirect_to
    else
    end
  end

  private
  def load_admin
    @admin = Crew::Admin.find(params[:id])
  end
  def admin_params
    params[:crew_admin][:confirmed_at] = Time.now
    params[:crew_admin][:confirmation_sent_at] = Time.now
    params.require(:crew_admin).permit(:name, :email, :password,
                                       :password_confirmation, :confirmed_at,
                                       :confirmation_sent_at)
  end
end
