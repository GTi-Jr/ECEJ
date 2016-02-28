require "rails_helper"

RSpec.describe User, type: :model do
	it "user can't go to concurrent events" do
		user = User.create! do |user|
			user.name         = "name"
			user.email        = "test@test.com"
			user.password     = "password"
			user.lot_id       = 1
			user.confirmed_at = DateTime.now
		end

		event_1 = Event.create! do |event|
			event.name        = "Evento 1"
			event.facilitator = "fac 1"
			event.limit       = 50
			event.start       = DateTime.now
			event.end         = DateTime.now + 2.hours
		end

		event_2 = Event.create! do |event|
			event.name        = "Evento 2"
			event.facilitator = "fac 2"
			event.limit       = 40
			event.start       = DateTime.now - 1.hour
			event.end         = DateTime.now + 1.hours
		end

		user.events << event_1

		expect(user.has_concurrent_event? event_2).to eq(true)
	end

	it "user can go to consecutive events" do
		user = User.create! do |user|
			user.name         = "name"
			user.email        = "test@test.com"
			user.password     = "password"
			user.lot_id       = 1
			user.confirmed_at = DateTime.now
		end

		event_1 = Event.create! do |event|
			event.name        = "Evento 1"
			event.facilitator = "fac 1"
			event.limit       = 50
			event.start       = DateTime.now
			event.end         = DateTime.now + 2.hours
		end

		event_2 = Event.create! do |event|
			event.name        = "Evento 2"
			event.facilitator = "fac 2"
			event.limit       = 40
			event.start       = DateTime.now + 2.hours
			event.end         = DateTime.now + 3.hours
		end

		user.events << event_1

		expect(user.has_concurrent_event? event_2).to eq(false)
	end
end
