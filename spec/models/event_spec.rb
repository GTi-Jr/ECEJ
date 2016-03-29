require "rails_helper"

RSpec.describe Event, type: :model do
	it "days should return days of the events" do
		event_1 = FactoryGirl.create(:event, start_time: DateTime.now + 1.day, 
																				 end_time: DateTime.now + 1.day + 2.hours)
		event_2 = FactoryGirl.create(:event, start_time: DateTime.now, 
																				 end_time: DateTime.now + 3.hours)

		expect(Event.days).to eq([{date: Date.today, events: [event_2]}, {date: Date.tomorrow, events: [event_1]}])
	end

	it "should save its users" do
		event = FactoryGirl.create(:event)

		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)

		event.add user_1
		event.add user_2

		expect(Event.find(event.id).users).to eq([user_1, user_2])
	end

	it "should generate subscription when user register into events" do
		event = FactoryGirl.create(:event)

		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)

		event.add user_1
		event.add user_2

		expect(Subscription.all.count).to eq(2)
	end

	it "should generate subscription when user register into events matching its users" do
		event = FactoryGirl.create(:event)

		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)

		event.add user_1

		expect(Subscription.first.user).to eq(user_1)
	end

	it "should remove its users properly" do
		event = FactoryGirl.create(:event)

		user_1 = FactoryGirl.create(:user)
		user_2 = FactoryGirl.create(:user)

		event.add user_1
		event.add user_2

		expect(event.users.first).to eq(user_1)

		event.remove user_1

		expect(event.users.first).to eq(user_2)
	end
end
