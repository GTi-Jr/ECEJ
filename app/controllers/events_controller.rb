class EventsController < ApplicationController
	before_action :authenticate_user!

	def enter_event
		event = Event.find(params[:id])

		event.users << current_user
	end
end
