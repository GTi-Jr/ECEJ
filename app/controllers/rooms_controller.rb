class RoomsController < ApplicationController
	before_action :authenticate_user!, :get_user
	before_action :get_hotel

	layout "dashboard"
	# PATCH
	# Insert current user into the selected room
	def insert_user_into_room
		room = Room.find(params[:id])

		if room.full?
			redirect_to rooms_url(@hotel_id), alert: "Quarto está cheio. Tente outro."
		else
			current_user.update(room_id: room.id)
			redirect_to rooms_url(@hotel_id), notice: "Você está no quarto #{room.number} do hotel #{room.hotel.name}"
		end
	end

	# PATCH
	# Exit room
	def exit_room
		if current_user.room.nil?
			redirect_to rooms_url(@hotel_id), alert: "Você já não está em quarto algum."
		elsif current_user.exit_room!
			redirect_to rooms_url(@hotel_id), notice: "Você saiu do quarto."
		else
			redirect_to rooms_url(@hotel_id), alert: "Não foi possível sair do quarto. Tente novamente."
		end
	end

	# GET
	# Index rooms by hotel
	def index
		hotel_id = params[:hotel_id]

		rooms = Room.select { |room| room.hotel_id == hotel_id }.sort_by { |room| room.number }

		@rooms_with_users = []

		@rooms.each do |room|
			@rooms_with_users << { room: room, users: room.users }
		end
	end

	private
		def get_hotel
		  @hotel_id = params[:hotel_id].to_i
		end
end
