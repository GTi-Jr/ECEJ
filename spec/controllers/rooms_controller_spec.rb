require "rails_helper"

RSpec.describe RoomsController, type: :controller do
	it "#insert_user_into_room should allocate user to the room" do
		user = FactoryGirl.create(:user)
		room = FactoryGirl.create(:room)
		sign_in user

		patch :insert_user_into_room, { id: room.id }

		expect(room.users.include? user).to eq(true)
	end

	it "#exit_room should remove user from room" do
		user = FactoryGirl.create(:user)
		room = FactoryGirl.create(:room)
		sign_in user

		room.users << user

		patch :exit_room

		expect(room.users.include? user).to eq(false)
	end

	it "#index should generate an empty array instance variable if Room.all.empty" do |variable|
		hotel = FactoryGirl.create(:hotel)
		get :index, { hotel: hotel.name }
		expect(assigns(:rooms_with_users)).to eq(Array.new)
	end

	it "#index should generate an array with rooms and its users filtered by hotel" do
		hotel = FactoryGirl.create(:hotel)

		room_1 = FactoryGirl.create(:room, hotel: hotel)
		room_2 = FactoryGirl.create(:room, hotel: hotel)

		user_1 = FactoryGirl.create(:user, room: room_1)
		user_2 = FactoryGirl.create(:user, room: room_1)
		user_3 = FactoryGirl.create(:user, room: room_2)

		get :index, { hotel: hotel.name }

		assigns(:rooms_with_users).to eq([{room: room_1, users: [user_1, user_2]}, 
																			{room: room_2, users: [user_3]}])
	end
end
