# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = Crew::Admin.new do |admin|
  admin.name = "ECEJ"
  admin.email = "ecej@ecej2016.com"
  admin.confirmed_at = Time.now
  admin.confirmation_sent_at = Time.now
  admin.password = ENV['ADMIN_PW']
  admin.password_confirmation = ENV['ADMIN_PW']
end

admin.save!

# lot1 = Lot.new do
  
# end
# lot1.save!

# lot2 = Lot.new
# lot2.save!
