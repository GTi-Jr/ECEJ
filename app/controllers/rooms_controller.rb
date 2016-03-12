class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :verify_register_conclusion
  before_action :get_rooms

  layout "dashboard"

  def new
  end

  def create_alocation
    room = Room.find(:id)
    vacancies = room.capacity
  end

  private
  def get_rooms
    @rooms = Room.all
  end
end
