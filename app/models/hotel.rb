class Hotel < ActiveRecord::Base
	validates :name,
						presence: true,
						uniqueness: true

	has_many :rooms

	def capacity
		capacity = 0
		rooms.all.each do |room|
			capacity += room.capacity
		end
		capacity
	end

	def people
		people = []
		rooms.each do |room|
			room.users.each do |user|
				people << user
			end
		end
		people
	end

	def number_of_people
		number_of_people = 0
		rooms.each do |room|
			number_of_people += room.users.count
		end
		number_of_people
	end
end
