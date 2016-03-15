class ExcelHandler
	attr_reader   :model
	attr_reader   :possible_columns
	attr_reader   :columns
	attr_accessor :excluded_columns

	# ExcelHandler.new model: User
	# uses the model User for the excel
	def initialize(args)
		@model            = args[:model]
		@possible_columns = get_possible_columns
	end

	# Choose the selected columns to display in the Excel
	# instance.choose_column [:lot, :name]
	def choose_columns(choosen_columns)
		# choosen_columns.map! { |column| column.downcase.to_sym }

		@columns = @possible_columns.keep_if do |column|
			condition = false

			choosen_columns.each do |choosen_column|
				condition = true if @possible_columns.include? choosen_column				
			end

			condition
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
			'avatar'
		]
	end

	protected
		def get_possible_columns
			columns = @model.columns.map { |column| column.name }.delete_if do |column|
				default_excluded_columns.include?(column)
			end

			columns.map { |column| column.humanize }
		end
end
