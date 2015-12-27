class Crew::LotsController < ApplicationController
  layout 'admin_layout'
  before_action :authenticate_crew_admin!
  before_action :load_lot, only: [:edit, :update]


  def index
    @lots = Lot.all
  end

  def new
    @lot = Lot.new    
  end

  def create
    @lot = Lot.new(lot_params)

    if @lot.save
      redirect_to crew_lots_path, notice: "Lote criado com sucesso"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @lot.update_attributes(lot_params)
      redirect_to edit_crew_lot_path(@lot), notice: "Lote editado com sucesso."
    else
      redirect_to edit_crew_lot_path(@lot), alert: "Não foi possível alterar lote."
    end
  end

  private
  def load_lot
    @lot = Lot.find(params[:id])    
  end

  def lot_params
    params.require(:lot).permit(:name, :number, :limit, :value_federated, 
                                :value_not_federated, :start_date, :end_date)
  end
end
