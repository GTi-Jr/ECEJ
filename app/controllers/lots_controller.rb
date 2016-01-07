class LotsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_eligibility

  def subscribe_into_lot_early
    @lot = Lot.find(params[:id])

    # Checks if the link is, indeed, to that user
    if current_user.confirmation_token.first(8) == params[:auth]
      if current_user.insert_into_lot(@lot)
        redirect_to user_root_path, notice: "Cadastrado(a) no #{@lot.name} com sucesso."
      else
        redirect_to user_root_path, alert: "Infelizmente, o lote já lotou."
      end
    else
      redirect_to user_root_path, alert: "O código de confirmação não lhe pertence."
    end
  end

  def subscribe_into_lot
    @lot = Lot.find(params[:id])

    if !@lot.is_full? && @lot.is_active?
      current_user.update(lot_id: @lot.id)
      redirect_to user_root_path, notice: "Você conseguiu sua vaga no lote #{@lot.number}"
    else
      redirect_to user_root_path, alert: "Infelizmente o lote está cheio."
    end
  end

  private 
    def check_eligibility
      redirect_to user_root_path, alert: "Você não pode se registrar neste lote." unless User.eligible.include?(current_user)
    end
end
