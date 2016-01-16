file = File.read("#{Rails.root}/lib/seeds/sheet.csv")
people = CSV.parse(file)

people.each do |row|
  user = User.new do |user|
    user.name = row[0]
    user.email = row[1]
    user.password = ENV['USER_PW']
    user.password_confirmation = ENV['USER_PW']
    user.confirmed_at = DateTime.now
    user.confirmation_sent_at = DateTime.now
    user.active = true
    user.lot_id = 2
  end
  user.save!
end
