class ExcelHandler
	attr_reader :model
	attr_reader :possible_columns
	attr_reader :columns

	# ExcelHandler.new model: User
	# uses the model User for the excel
	def initialize(args)
		@model            = args[:model]
		@possible_columns = get_possible_columns
	end

	# Params should be a hash
	# params.to_h
	def get_rows(params)
	 	# Gets an array with the columns names from the params
	 	selected_columns = get_selected_columns_from_params(params)
	 	# Assigns @columns and filters it so it can only use permitted columns
	 	select_columns(selected_columns)

	 	rows = []
	 	
	 	# Assigns a user to each row
	 	User.order(model_order) do |user|
	 		rows << { user: user }
	 	end

	 	# If payments are set to show, include them into the row
	 	if params[:payments]
	 		rows.each do |row|
	 			row.merge!({ payment: row[:user].payment })
	 		end
	 	end

	 	rows
	end

	# Returns an array with the selected columns from the parameters
	def get_selected_columns_from_params(params)
		columns = []

		params[:selected_columns].each do |key, value|
			columns << key if value == true
		end

		columns
	end

	# Choose the selected columns to display in the Excel
	# select_columns(["Lot", "Name"])
	def select_columns(choosen_columns)
		@columns = []

		choosen_columns.each do |choosen_column|
			@columns << choosen_column if @possible_columns.include? choosen_column				
		end
	end

	def default_excluded_columns
		[
			'id',
			'encrypted_password',
			'reset_password_token',
			'reset_password_sent_at',
			'remember_created_at',
			'sign_in_count',
			'current_sign_in_at',
			'last_sign_in_at',
			'current_sign_in_ip',
			'last_sign_in_ip',
			'confirmation_token',
			'confirmed_at',
			'confirmation_sent_at',
			'updated_at',
			'avatar',
			'lot_id',
			'user_id'
		]
	end

	protected
		def get_possible_columns
			columns = @model.columns.map { |column| column.name }.delete_if do |column|
				default_excluded_columns.include?(column)
			end

			columns.map { |column| column.humanize }
		end

		# Use @columns and symbolizes each element so it can access User attributes
	 	# @columns = ["Name", "Lot"]
	 	# symbolize_columns = [:name, :lot]
	 	# User.new(name: 'John)[:name] #=> 'John'
		def symbolize_columns
			@columns.map { |column| column.downcase.to_sym }
		end

		# Sets the ordering parameter for the model
		def model_order(params)
			if params.require(:order)
				params.require(:order).to_sym
			else
				:id
			end
		end
end
