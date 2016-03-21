class HotelsController < ApplicationController
	before_action :authenticate_user!, :get_user

	layout "dashboard"

	# GET /hotels
	# Lists all hotels ordered by name
	def index
		@hotels = Hotel.order(:name)
	end
end
