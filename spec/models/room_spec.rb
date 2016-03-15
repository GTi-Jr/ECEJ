require "rails_helper"

RSpec.describe Room, type: :model do
	it "#insert_user should insert user" do
		user = FactoryGirl.create(:user)
		room = FactoryGirl.create(:room)

		room.insert_user user

		expect(room).to eq(user.room)
	end
end
