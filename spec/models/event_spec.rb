require "rails_helper"

RSpec.describe Event, type: :model do
	it "days should return days of the events" do
		event_1 = FactoryGirl.create(:event, start_time: DateTime.now + 1.day, 
																				 end_time: DateTime.now + 1.day + 2.hours)
		event_2 = FactoryGirl.create(:event, start_time: DateTime.now, 
																				 end_time: DateTime.now + 3.hours)

		expect(Event.days).to eq([Date.today, Date.tomorrow])
	end
end
