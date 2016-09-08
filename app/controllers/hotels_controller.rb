class HotelsController < ApplicationController
	before_action :authenticate_user!, :get_user
	before_action :verify_register_conclusion
	before_action :user_must_have_paid
	before_action :eita
	layout "dashboard"

	# GET /hotels
	# Lists all hotels ordered by name
	def index
		@hotels = Hotel.order(:name)
	end

	def eita
	  redirect_to authenticated_user_root_path
	end
end
