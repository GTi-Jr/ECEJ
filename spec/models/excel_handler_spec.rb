require 'rails_helper'

RSpec.describe ExcelHandler, type: :model do
	it 'instance.model should be a class' do
		excel = ExcelHandler.new(model: User)

		expect(excel.model).to be(User)
	end

	it 'should exclude default excluded columns' do
		excel = ExcelHandler.new(model: User)

		condition = false

		excel.possible_columns.each do |column|
			condition = true if excel.default_excluded_columns.include?(column)
		end

		expect(condition).to eq(false)
	end

	it 'should select columns within possible_columns' do
		excel = ExcelHandler.new(model: User)

		columns = [excel.possible_columns.first, 'lorem_ipsum_dolor_amet']

		excel.select_columns(columns)

		expect(excel.columns).to eq([columns.first])
	end

	it 'should use the parameters to get the columns' do
		excel = ExcelHandler.new model: User
		params = ActionController::Parameters.new({ filter: { "Lot"=> "1", 
																												  "Name"=> "1"}, 
																								order: "Name" })

		columns = excel.get_selected_columns_from_params(params, :filter)

		expect(columns).to eq(['Lot', 'Name'])
	end

	it 'should order records' do
		excel = ExcelHandler.new model: User
		params = ActionController::Parameters.new({ filter: { "Lot"=> "1", 
																												  "Name"=> "1"}, 
																								order: "Name" })

		user_1 = FactoryGirl.create :user, name: 'Caio'
		user_2 = FactoryGirl.create :user, name: 'Lucas'
		user_3 = FactoryGirl.create :user, name: 'John'

		rows = excel.get_rows(params, selected_columns: :filter, order: :order)

		expect(rows).to eq([user_1, user_3, user_2])
	end

	it 'should order records by id if no order is defined' do
		excel = ExcelHandler.new model: User
		params = ActionController::Parameters.new({ filter: { "Lot"=> "1", 
																												  "Name"=> "1"}})

		user_1 = FactoryGirl.create :user, name: 'Caio'
		user_2 = FactoryGirl.create :user, name: 'Lucas'
		user_3 = FactoryGirl.create :user, name: 'John'

		rows = excel.get_rows(params, selected_columns: :filter)

		expect(rows).to eq([user_1, user_2, user_3])
	end

	it 'should filter values' do
		excel = ExcelHandler.new model: User
		params = ActionController::Parameters.new({ filter: { "Lot"=> "1", 
																												  "Name"=> "1"}})

		user_1 = FactoryGirl.create :user, name: 'Caio'
		user_2 = FactoryGirl.create :user, name: 'Lucas'
		user_3 = FactoryGirl.create :user, name: 'John'

		params = ActionController::Parameters.new({ filter: { "Lot"=> "1", 
																												  "Name"=> "1"}, 
																								order:  "Name",
																								values: { 'name' => 'caio'}})
		
		expect(rows).to eq([user_1])
	end
end
