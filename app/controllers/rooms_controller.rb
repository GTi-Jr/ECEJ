class RoomsController < ApplicationController
	before_action :authenticate_user!
	# PATCH
	# Insert current user into the selected room
	def insert_user_into_room
		room = Room.find(params[:room_id])

		if room.full?
			redirect_to authenticated_user_root_path, alert: "Quarto está cheio. Tente outro."
		else
			room.insert_user current_user
			redirect_to authenticated_user_root_path, notice: "Você está no quarto #{room.number} do hotel #{room.hotel}"
		end
	end

	# PATCH
	# Exit room
	def exit_room
		if current_user.room.nil?
			redirect_to :back, alert: "Você já não está em quarto algum."
		elsif current_user.exit_room!
			redirect_to authenticated_user_root_path, notice: "Você saiu do quarto."
		else
			redirect_to :back, alert: "Não foi possível sair do quarto. Tente novamente."
		end
	end

	# GET
	# Index rooms by hotel
	def index
		rooms = Room.where(hotel: params[:hotel])
		@rooms_with_users = []

		rooms.each do |room|
			@rooms_with_users << { room: room, users: room.users }
		end
	end
end
