class Hotel < ActiveRecord::Base
	validates :name,
						presence: true,
						uniqueness: true

	has_many :rooms

end
