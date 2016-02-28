FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Testing John #{n}" }
		sequence(:email) { |n| "test_user_#{n}@test.com" }
		password "123456789"
		password_confirmation "123456789"
		confirmed_at { DateTime.now }
		lot { Lot.first }
		transport_required "Sim"
		general_register "9999999999999"
		cpf "604.771.534-61" # Random valid CPF
		birthday { 20.years.ago }
		phone "(99) 99999-9999"
		federation "Federation"
		junior_enterprise "EJ"
		job "Job"
		university "University"
		completed true
		state "State"
		city "City"
		street "Street"
		cep "99999-999"
	end

	factory :hotel do 
		sequence(:name) { |n| "Hotel name #{n}" }
		extra_info "Extra information"
	end

	factory :room do
		sequence(:name) { |n| "Room name #{n}" }
		sequence(:number) { |n| n }
		capacity 4
		extra_info "Extra information"
	end
end
