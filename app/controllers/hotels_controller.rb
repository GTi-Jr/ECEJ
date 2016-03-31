class HotelsController < ApplicationController
	before_action :authenticate_user!, :get_user
	before_action :user_must_have_paid

	layout "dashboard"

	# GET /hotels
	# Lists all hotels ordered by name
	def index
		@hotels = Hotel.order(:name)
	end
end
