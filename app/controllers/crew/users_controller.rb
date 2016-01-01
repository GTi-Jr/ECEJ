class Crew::UsersController < ApplicationController
  # Only admins can use this controller
  before_action :authenticate_crew_admin!
  before_action :load_user, only: [:show, :edit, :update]

  layout 'admin_layout'

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to admin_root, notice: "Usuário criado com sucesso"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to admin_root
    else
      render :new
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
    params.require(:user).permit(:name, :general_register, :cpf, :birthday, :gender,
                                 :avatar, :phone, :special_needs, :federation,
                                 :junior_enteprise, :enterprise_office, :university,
                                 :city, :street, :postal_code, :complement)
  end
end
