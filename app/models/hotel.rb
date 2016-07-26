class Hotel < ActiveRecord::Base
	validates :name,
						presence: true,
						uniqueness: true

	has_many :rooms

	mount_uploader :image, ImageUploader
	mount_uploader :room_image, ImageUploader
	mount_uploader :blueprint, ImageUploader

	# Create multiple rooms for the hotel.
	def create_rooms(rooms_params)
		rooms_params[:extra_info] ||= ""

		rooms_params[:range].each do |number|
			rooms << Room.create( number: number.to_i,
													  capacity: rooms_params[:capacity].to_i,
													  extra_info: rooms_params[:extra_info],
													  name: rooms_params[:name] )
		end
	end

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
