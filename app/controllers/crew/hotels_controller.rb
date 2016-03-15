class Crew::HotelsController < ApplicationController
	layout "admin_layout"

	before_action :authenticate_crew_admin!
	before_action :load_hotel, only: [:show, :edit, :update, :destroy]

	# GET
	# Indexes all hotels
	def index
		@hotels = Hotel.all
	end

	# GET
	# Show hotel
	def show
	end

	# GET
	# New hotel page
	def new
		@hotel = Hotel.new
	end

	# POST
	def create
		@hotel = Hotel.new(hotel_params)

		if @hotel.save
			redirect_to crew_hotels_path, notice: "Hotel cadastrado com sucesso."
		else
			render :new
		end
	end

	# GET
	# Edit page
	def edit
	end

	# PATCH
	# Edit hotel
	def update
		if @hotel.update(hotel_params)
			redirect_to crew_hotels_path, notice: "Hotel editado com sucesso."
		else
			render :edit
		end
	end

	# DELETE
	# Delete hotel
	def destroy
		if @hotel.destroy
			redirect_to crew_hotels_path, notice: "Hotel excluído."
		else
			redirect_to crew_hotels_path, alert: "Não foi possível excluir o hotel."
		end
	end

	private
		# Strong params
		def hotel_params
			params.require(:hotel).permit(:name, :extra_info)
		end

		def load_hotel
			@hotel = Hotel.find(params[:id])
		end
end
