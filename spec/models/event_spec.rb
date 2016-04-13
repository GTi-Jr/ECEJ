require "rails_helper"

RSpec.describe Event, type: :model do
	it "days should return days of the events" do
		event_1 = FactoryGirl.create(:event, start: DateTime.now + 1.day, 
																				 end: DateTime.now + 1.day + 2.hours)
		event_2 = FactoryGirl.create(:event, start: DateTime.now, 
																				 end: DateTime.now + 3.hours)
		event_3 = FactoryGirl.create(:event, start: DateTime.now, 
																				 end: DateTime.now + 3.hours)

		expect(Event.days).to eq([
															{ date: Date.today, events: [event_2, event_3] }, 
															{ date: Date.tomorrow, events: [event_1] }
														])
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

	it "user can't go to concurrent events" do
		user = FactoryGirl.create(:user)

		event_1 = FactoryGirl.create(:event, start: 2.hour.from_now, 
																				 end:   4.hours.from_now)
		event_2 = FactoryGirl.create(:event, start: 3.hours.from_now, 
																				 end:   5.hours.from_now)
		event_3 = FactoryGirl.create(:event, start: 1.hours.from_now, 
																				 end:   10.hours.from_now)

		user.events << event_1

		expect(user.has_concurrent_event? event_2).to eq(true)
		expect(user.has_concurrent_event? event_3).to eq(true)
	end

	it "user can go to consecutive events" do
		user = FactoryGirl.create(:user)

		event_1 = FactoryGirl.create(:event, start: DateTime.now, 
																				 end: DateTime.now + 2.hours)
		event_2 = FactoryGirl.create(:event, start: DateTime.now + 2.hours, 
																				 end: DateTime.now + 3.hours)

		user.events << event_1

		expect(user.has_concurrent_event? event_2).to eq(false)
	end

	it 'should return its days' do
		event_1 = FactoryGirl.create(:event, start: 1.second.from_now, 
																				 end:   3.seconds.from_now)
		event_2 = FactoryGirl.create(:event, start: 1.second.from_now, 
																				 end:   50.hours.from_now)

		expect(event_1.occurring_days.to_a).to eq([Date.today])
		expect(event_2.occurring_days).to eq(Date.today..Date.tomorrow.tomorrow)
	end

	it 'should return its hours by day' do
		event_1 = FactoryGirl.create(:event, start: 1.second.from_now, 
																				 end:   3.seconds.from_now)
		event_2 = FactoryGirl.create(:event, start: 1.second.from_now, 
																				 end:   50.hours.from_now)
		event_3 = FactoryGirl.create(:event, start: 1.second.from_now, 
																				 end:   30.hours.from_now)

		expect(event_1.occurring_hours).to eq([{ day: Date.today, hours: [event_1.start.hour] }])

		expect(event_2.occurring_hours).to eq([{ day: Date.today,             hours: (event_2.start.hour..23).to_a },
																					{ day: Date.tomorrow,          hours: (0..23).to_a },
																					{ day: Date.tomorrow.tomorrow, hours: (0..event_2.end.hour).to_a }
																				 ])

		expect(event_3.occurring_hours).to eq([{ day: Date.today,    hours: (event_3.start.hour..23).to_a },
																					{ day: Date.tomorrow, hours: (0..event_3.end.hour).to_a }
																				 ])
	end
end
