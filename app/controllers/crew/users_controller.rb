class Crew::UsersController < ApplicationController
  # Only admins can use this controller
  before_action :authenticate_crew_admin!
  before_action :load_user, only: [:edit, :update, :disqualify, :requalify]

  layout 'admin_layout'

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.active = true
    @user.password = "ecej2016"
    @user.password_confirmation = "ecej2016"
    if @user.save
      redirect_to edit_crew_user_path(@user), notice: "Usuário criado com sucesso."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to edit_crew_user_path(@user), notice: "Usuário atualizado com sucesso."
    else
      render :new
    end
  end

  def disqualify
    if @user.update_attribute(:active, false)
      redirect_to edit_crew_user_path(@user), notice: "#{@user.name} foi desqualificado"
    else
      redirect_to edit_crew_user_path(@user), alert: "Não foi possível desqualificar #{@user.name}."
    end
  end

  def requalify
    if @user.update_attribute(:active, true)
      redirect_to edit_crew_user_path(@user), notice: "#{@user.name} foi requalificado"
    else
      redirect_to edit_crew_user_path(@user), alert: "Não foi possível requalificar #{@user.name}."
    end
  end

  def qualified
    @users = User.allocated
  end

  def disqualified
    @users = User.disqualified
  end

  def waiting_list
    @users = User.eligible
  end

  private
  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :general_register, :cpf, :birthday, :gender,
                                 :avatar, :phone, :special_needs, :federation,
                                 :junior_enteprise, :job, :enterprise_office, :university,
                                 :city, :street, :postal_code, :complement, :payment_status)
  end
end
