class HotelsController < ApplicationController
	before_action :authenticate_user!
	
	# GET /hotels
	# Lists all hotels ordered by name
	def index
		@hotels = Hotel.order(:name)
	end
end
