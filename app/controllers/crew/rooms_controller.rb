class Crew::RoomsController < ApplicationController
  layout 'admin_layout'

  before_action :authenticate_crew_admin!
  before_action :set_room, only: [:edit, :update, :destroy]
  before_action :set_hotel_names, only: [:new, :edit, :new_rooms]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.includes(:hotel, :users).order('hotels.name ASC, number')

    respond_to do |format|
      format.html
      format.json { render json: @rooms }
    end
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
    @users = @room.users
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    @room.hotel = Hotel.find_by_name(params[:room][:hotel])

    respond_to do |format|
      if @room.save
        format.html { redirect_to crew_rooms_path, notice: 'Quarto foi criado com sucesso.' }
        format.json { render :edit, status: :created, location: @room }
      else
        format.html do
          set_hotel_names
          render :new
        end

        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    @room.hotel = Hotel.find_by_name(params[:room][:hotel])

    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to crew_rooms_path, notice: 'Quarto atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to crew_rooms_path, notice: 'Quarto foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  # GET /rooms/new_rooms
  def new_rooms
  end

  # POST /rooms/create_rooms
  def create_rooms
    hotel       = Hotel.find_by_name(params[:hotel])
    upper_range = params[:upper_range]
    down_range  = params[:down_range]

    range = down_range..upper_range

    hotel.create_rooms( { range: range, capacity: params[:capacity],
                          extra_info: params[:extra_info]} )

    redirect_to crew_rooms_path
  end

  def remove_user
    @user = User.find(params[:user_id])

    if @user.exit_room!
      redirect_to :back, notice: "#{@user.first_name} foi removido do quarto."
    else
      redirect_to :back, alert: "Não foi possível remover #{@user.first_name} do quarto. Tente novamente."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:number, :capacity, :extra_info)
    end

    def set_hotel_names
      @hotels = []

      Hotel.order(:name).each do |hotel|
        @hotels << hotel.name
      end
    end
end
