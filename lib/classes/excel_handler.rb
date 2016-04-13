class ExcelHandler
	attr_reader :model
	attr_reader :possible_columns
	attr_reader :columns
	attr_reader :records

	# ExcelHandler.new model: User
	# uses the model User for the excel
	def initialize(args)
		@model            = args[:model]
		@possible_columns = get_possible_columns
	end

	# Params should be a hash
	# params.to_h
	# options = { selected_columns: #, selected_values: #, order: #, strictness: # }
	def get_rows(params, options = {})
	 	# Gets an array with the columns names from the params
	 	selected_columns = get_selected_columns_from_params(params, options[:selected_columns])
	 	# Assigns @columns and filters it so it can only use permitted columns
	 	select_columns(selected_columns)
	 	# Selects the desired order
	 	order = model_order(params[options[:order]])

	 	if params[options[:selected_values]]
	 		@records = get_records(params, options)
	 	else
	 		@records = @model.order(order)
	 	end
	end

	# Returns an array with the selected columns from the parameters
	def get_selected_columns_from_params(params, selected_columns)
		columns = []
		
		params[selected_columns].each do |key, value|
			columns << key if value == "1" # Form value for checked
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

	# Filters the records according to selected values
	def get_records(params, options = {})		
		@model.where(query_string(params[options[:selected_values]], 
																	  params[options[:strictness]]))
	end

	# Returns a query string for SQL query
	def query_string(selected_values, strictness)
		sql = ""

		if selected_values
			selected_values.each do |key, value|
				sql << " #{key} LIKE '%#{value}%' "

				sql << query_join_strict(strictness) unless key.downcase == @columns.last.downcase
			end
		end

		sql
	end

	def table_name
		@model.table_name
	end

	def select_query(selected_columns)
		selected_columns ? selected_columns.join(', ').concat(' ') : ' * '
	end

	# Method used in #query_string to define the aggregation logic
	def query_join_strict(is_strict)
		is_strict ? 'AND' : 'OR'
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
			'user_id',
			'paid_on'  #Gambs. Remove this later
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
		@columns.map { |column| column.to_symbol }
	end

	# Sets the ordering parameter for the model
	def model_order(order)
		if order
			order.to_symbol
		else
			:id
		end
	end
end
