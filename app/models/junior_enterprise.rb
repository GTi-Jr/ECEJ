# JE = Junior Enterprise
class JuniorEnterprise
	attr_reader :name
	attr_reader :users_ids

	def initialize(name)
		@name = name
		@users_ids = []

		User.where(junior_enterprise: name).each do |user|
			@users_ids << user.id unless user.id.in? @users_ids
		end
	end

	def users
		User.find(@users_ids)
	end

	# Returns an array with all junior enterprises
	def self.all
		jes = []

		User.all.each do |user|
			junior_enterprise = self.new user.junior_enterprise
			jes << junior_enterprise unless junior_enterprise.in? jes
		end

		jes
	end
end
