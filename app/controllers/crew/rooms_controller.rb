class Crew::RoomsController < ApplicationController
  layout 'admin_layout'

  before_action :authenticate_crew_admin!
  before_action :set_room, only: [:edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @hotels = []

    Hotel.order(:name).each do |hotel|
      @hotels << hotel.name
    end
  end

  # GET /rooms/1/edit
  def edit
    @hotels = Hotel.all
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
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to edit_crew_room_path(@room), notice: 'Quarto atualizado com sucesso.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:number, :capacity, :extra_info)
    end
end
