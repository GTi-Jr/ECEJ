class LotsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_eligibility, except: [:subscribe_into_lot_early]
  before_action :user_cant_be_in_a_lot

  def subscribe_into_lot_early
    @lot = Lot.find(params[:id])
    # Checks if the link is, indeed, to that user
    if current_user.confirmation_token.first(8) == params[:auth]
      if !@lot.is_full? && current_user.insert_into_lot(@lot)
        redirect_to authenticated_user_root_path, notice: "Cadastrado(a) no #{@lot.name} com sucesso."
      else
        redirect_to authenticated_user_root_path, alert: "Infelizmente, o lote já lotou."
      end
    else
      redirect_to authenticated_user_root_path, alert: "Parece que você é muito amiguinho de alguém que recebeu o acesso antecipado né? Hehe."
    end
  end

  def subscribe_into_lot
    @lot = Lot.active_lot
    if @lot.nil?
      if !@lot.is_full? && @lot.is_active?
        if current_user.update(lot_id: @lot.id)
          UsersLotMailer.allocated(current_user)
          redirect_to authenticated_user_root_path, notice: "Você conseguiu sua vaga no lote #{@lot.number}"
        else
          redirect_to authenticated_user_root_path, notice: "Não foi possível fazer cadastro no lote #{@lot.number}"
        end
      else
        redirect_to authenticated_user_root_path, alert: "Infelizmente o lote está cheio."
      end
    else
      redirect_to authenticated_user_root_path, alert: "Não lote disponível no momento."
    end
  end

  private
    def check_eligibility
      redirect_to authenticated_user_root_path, alert: "Você não pode se registrar neste lote." unless User.eligible.include?(current_user)
    end

    def user_cant_be_in_a_lot
      redirect_to authenticated_user_root_path if current_user.lot.present?
    end
end
