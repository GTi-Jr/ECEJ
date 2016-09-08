class RoomsController < ApplicationController
	before_action :authenticate_user!, :get_user
	before_action :get_hotel
	before_action :user_must_have_paid
	before_action :eita
	layout "dashboard"
	# PATCH
	# Insert current user into the selected room
	def insert_current_user_into_room
		room = Room.find(params[:id])

		if room.full?
			redirect_to rooms_url(@hotel.id), alert: "Quarto está cheio. Tente outro."
		else
			current_user.update(room_id: room.id)
			redirect_to rooms_url(@hotel.id), notice: "Você está no quarto #{room.number} do hotel #{room.hotel.name}"
		end
	end

	# PATCH
	# Exit room
	def exit_room
		if current_user.room.nil?
			redirect_to rooms_url(@hotel.id), alert: "Você já não está em quarto algum."
		elsif current_user.exit_room!
			redirect_to rooms_url(@hotel.id), notice: "Você saiu do quarto."
		else
			redirect_to rooms_url(@hotel.id), alert: "Não foi possível sair do quarto. Tente novamente."
		end
	end

	# GET
	# Index rooms by hotel
	def index
		@rooms = Room.includes(:users).where(hotel: @hotel).order(:number)

		@room_image_url = @hotel.room_image_url
	end

	def eita
	  redirect_to authenticated_user_root_path
	end

	private
		def get_hotel
		  @hotel = Hotel.find(params[:hotel_id])
		end
end
