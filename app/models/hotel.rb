class Hotel < ActiveRecord::Base
	validates :name,
						presence: true,
						uniqueness: true

	has_many :rooms

	# Returns the capcity of the hotel based on the sum of the capacity of its rooms
	def capacity
		capacity = 0
		rooms.all.each do |room|
			capacity += room.capacity
		end
		capacity
	end

	# Returns an array with all users inside the rooms of the hotel
	def users
		users = []
		rooms.each do |room|
			room.users.each do |user|
				users << user
			end
		end
		users
	end

	# Returns the number of people inside the hotel
	def number_of_people
		users.length
	end

	# OVERRIDE
	def to_s
		name
	end
end
