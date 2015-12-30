class LotsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_eligibility

  def subscribe_into_lot
    @lot = Lot.find(params[:id])

    if current_user.insert_into_lot(@lot)
      redirect_to user_root_path, notice: "Cadastrado(a) no #{lot.name} com sucesso."
    else
      redirect_to user_root_path, alert: "Infelizmente, o lote já lotou."
    end
  end

  private 
    def check_eligibility
      redirect_to user_root unless User.eligible.include?(current_user)
    end
end
