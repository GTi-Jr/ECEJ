# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = Crew::Admin.new do |admin|
  admin.name = "ECEJ_2016"
  admin.email = "ecej@ecej.com"
  admin.password = "caiocaio"
  admin.password_confirmation = "caiocaio"
  admin.confirmed_at = Time.now # skip confirmation
  admin.confirmation_sent_at = Time.now # skip confirmation
end
