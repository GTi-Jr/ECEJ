require "rails_helper"

RSpec.describe User, type: :model do
	it "user can't go to concurrent events" do
		user = FactoryGirl.create(:user)

		event_1 = FactoryGirl.create(:event, start: DateTime.now, 
																				 end: DateTime.now + 2.hours)
		event_2 = FactoryGirl.create(:event, start: 1.hour.ago, 
																				 end: DateTime.now + 1.hours)

		user.events << event_1

		expect(user.has_concurrent_event? event_2).to eq(true)
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
end
