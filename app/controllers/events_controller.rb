class EventsController < ApplicationController
	before_action :authenticate_user!, :get_user
	before_action :verify_register_conclusion
	before_action :user_must_have_paid

	layout "dashboard"
	# GET
	# Lists all events ordered by the starting time
	# Event.days returns an array of hashes. Each hash has a day and all of its events
	# ordered by date
	def index
		@days = Event.join_events_by_time
		@now = DateTime.now
	end

	# Patch
	# Adds current user to event
	def enter_event
		event = Event.find(params[:id])
		more_one_day_events = Event.where(name: event.name)

		if event.nil?
			redirect_to :back, alert: "Erro."
		elsif event.full?
			redirect_to :back, alert: "A programação chegou na sua capacidade máxima."
		elsif current_user.has_concurrent_event?(event)
			redirect_to :back, alert: "Você possui outra programação no mesmo horário!"
		else
			event.add current_user

			more_one_day_events.each do |eq_event|
				if eq_event.full?
					redirect_to :back, alert: "A programação chegou na sua capacidade máxima."
				else
					eq_event.add current_user
				end
			  
			end

			if current_user.in? event.users
				redirect_to :back, notice: "Você garantiu sua vaga no(a) #{event.name}!"
			else
				redirect_to :back, alert: "Não foi possível garantir sua vaga no(a) #{event.name}. Tente novamente"
			end
		end
	end

	# Patch
	# Excludes the current user from the event
	def exit_event
		event = Event.find(params[:id])
		more_one_day_events = Event.where(name: event.name)

		event.remove current_user

		more_one_day_events.each do |eq_event|
			eq_event.remove current_user
		end

		if current_user.in? event.users
			redirect_to :back, notice: "Não foi possível sair da programação."
		else
			redirect_to :back, notice: "Você saiu da programação."
		end
	end
end
