class Crew::EventsController < ApplicationController
  before_action :authenticate_crew_admin!
  before_action :load_event, only: [:edit, :update, :destroy]
  layout 'admin_layout'

  def index
    @events = Event.includes(:users).order(:start)
  end

  def new
    now = Time.now - Time.now.sec # Excluding the seconds so the time can be pretty
    @event = Event.new do |event|
      event.start = now
      event.end = now + 2.hours
    end
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to crew_events_path, notice: "Evento criado com sucesso."
    else
      render :new
    end
  end

  def edit
    @users = @event.users
  end

  def update
    if @event.update(event_params)
      redirect_to edit_crew_event_path(@event), notice: 'Evento editado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    if @event.destroy
      redirect_to crew_events_path, notice: "Evento excluído."
    else
      redirect_to crew_events_path, notice: "Não foi possível excluir evento."
    end
  end

  def show
    @event = Event.find(params[:id])
    @users = @event.users
  end

  def remove_user
    user  = User.find(params[:user_id])
    event = Event.find(params[:id])

    event.remove(user)

    redirect_to :back, notice: "#{user.email} foi removido de #{event.name}."
  end

  private

  def event_params
    params.require(:event).permit(:name, :facilitator, :facilitator_image,
                                  :description, :limit, :start, :end)
  end

  def load_event
    @event = Event.find(params[:id])
  end
end
