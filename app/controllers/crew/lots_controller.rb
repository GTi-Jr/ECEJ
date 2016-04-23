class Crew::LotsController < ApplicationController
  layout 'admin_layout'
  before_action :authenticate_crew_admin!
  before_action :load_lot, only: [:show, :edit, :update, :destroy]


  def index
    @lots = Lot.all
  end

  def show
    @users = @lot.users
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
    if @lot.update(lot_params)
      redirect_to edit_crew_lot_path(@lot), notice: "Lote editado com sucesso."
    else
      redirect_to edit_crew_lot_path(@lot), alert: "Não foi possível alterar lote."
    end
  end

  def destroy
    if @lot.destroy
      redirect_to crew_lots_path, notice: "Lote apagado com sucesso."
    else
      redirect_to crew_lots_path, notice: "Erro ao apagar o lote #{@lot.number}"
    end
  end

  private
  def load_lot
    @lot = Lot.find(params[:id])
  end

  def lot_params
    params.require(:lot).permit(:name, :number, :limit, :value_federated,
                                :value_not_federated, :start_date, :end_date,
                                :deadline_1, :deadline_2, :deadline_3, :deadline_4)
  end
end
