file = File.read("#{Rails.root}/lib/seeds/almej_2.csv")
people = CSV.parse(file)
admin = Crew::Admin.new

people.each do |row|
  email = row[1]

  user = User.find_by email: email

  UserMailer.quartos_antecipados(user).deliver
end
