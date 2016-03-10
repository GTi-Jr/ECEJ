class HotelsController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@hotels = Hotel.all.order(:name)
	end
end
