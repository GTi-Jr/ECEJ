class Crew::EventsController < ApplicationController
  before_action :authenticate_crew_admin!
  before_action :load_event, only: [:edit, :update, :destroy]
  layout 'admin_layout'

  def index
    @events = Event.all.order(:start)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save!
      redirect_to crew_events_path, notice: "Evento criado com sucesso."
    else
      render :new
    end
  end

  def edit    
  end

  def update
    if @event.update(event_params)
      redirect_to edit_crew_event_path(@event), notice: "Evento editado com sucesso."
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

  private
    def event_params
      params.require(:event).permit(:name, :facilitator, :limit, :start, :end)
    end

    def load_event
      @event = Event.find(params[:id])
    end
end
