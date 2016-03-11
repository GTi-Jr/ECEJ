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

	it "#index should generate an empty array instance variable if Room.all.empty"
	
	it "#index should generate an array with rooms and its users filtered by hotel"
end
