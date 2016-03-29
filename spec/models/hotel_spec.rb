require "rails_helper"

RSpec.describe Hotel, type: :model do
	it "hotel capacity must be the sum of its room capacity" do
		hotel = FactoryGirl.create(:hotel)

		room_1 = FactoryGirl.create(:room, capacity: 4, hotel: hotel)
		room_2 = FactoryGirl.create(:room, capacity: 3, hotel: hotel)

		expect(hotel.capacity).to eq(7)
	end

	it "people within hotel must be the people within its rooms" do
		hotel = FactoryGirl.create(:hotel)

		room_1 = FactoryGirl.create(:room, hotel: hotel)
		room_2 = FactoryGirl.create(:room, hotel: hotel)

		user_1 = FactoryGirl.create(:user, room: room_1)
		user_2 = FactoryGirl.create(:user, room: room_1)
		user_3 = FactoryGirl.create(:user, room: room_2)
		user_4 = FactoryGirl.create(:user, room: room_2)

		expect(hotel.users).to eq([user_1, user_2, user_3, user_4])
	end

	it "Hotel people number must be the sum of its rooms' people number" do
		hotel = FactoryGirl.create(:hotel)

		room_1 = FactoryGirl.create(:room, hotel: hotel)
		room_2 = FactoryGirl.create(:room, hotel: hotel)

		user_1 = FactoryGirl.create(:user, room: room_1)
		user_2 = FactoryGirl.create(:user, room: room_1)
		user_3 = FactoryGirl.create(:user, room: room_1)
		user_4 = FactoryGirl.create(:user, room: room_2)

		expect(hotel.number_of_people).to eq(4)
	end
end
