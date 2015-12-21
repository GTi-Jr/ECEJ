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
  admin.password = "caiocaio"#ENV["ADMIN_PW"]
  admin.password_confirmation = "caiocaio"#ENV["ADMIN_PW"]
end

admin.save!


user_unconfirmed_out_of_time = User.new do |user|
  user.name = "user_unconfirmed_out_of_time"
  user.email = "user_unconfirmed_out_of_time@email.com"
  user.confirmed_at = Time.now
  user.confirmation_sent_at = Time.now
  user.created_at = DateTime.new(2015,12,1,0,0,0,'-3') #01/12/2015 - 00:00 -3 GMT
  user.password = "caiocaio"
  user.password_confirmation = "caiocaio"
end
user_unconfirmed_out_of_time.save!

user_unconfirmed_in_of_time = User.new do |user|
  user.name = "user_unconfirmed_in_of_time"
  user.email = "user_unconfirmed_in_of_time@email.com"
  user.confirmed_at = Time.now
  user.confirmation_sent_at = Time.now
  user.created_at = DateTime.yesterday
  user.password = "caiocaio"
  user.password_confirmation = "caiocaio"
end
user_unconfirmed_in_of_time.save!
