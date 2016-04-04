require 'rails_helper'

RSpec.describe JuniorEnterprise, type: :model do
	it 'should be able to access its users' do
		user_1 = FactoryGirl.create :user
		user_2 = FactoryGirl.create :user

		je = JuniorEnterprise.new user_1.junior_enterprise

		expect(je.users).to eq([user_1, user_2].sort_by {|user| user.name })
	end
end
