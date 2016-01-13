# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Examples:

#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = Crew::Admin.new do |admin|
  admin.name = "ECEJ"
  admin.email = "ecej@ecej2016.com"
  admin.confirmed_at = Time.now
  admin.confirmation_sent_at = Time.now
  admin.password = Rails.application.secrets.ecej_admin_password
  admin.password_confirmation = Rails.application.secrets.ecej_admin_password_confirmation
end
admin.save!

lot1 = Lot.new do |lot|
  lot.name = "Primeiro lote"
  lot.number = 1
  lot.limit = 50
  lot.start_date = DateTime.new(2016, 1, 10, 0, 0, 0 , '-3')
  lot.end_date = DateTime.new(2016, 1, 11, 23, 59, 59 , '-3')
  lot.deadline_1 = DateTime.new(2016, 1, 25, 23, 59, 59 , '-3')
  lot.deadline_2 = DateTime.new(2016, 2, 22, 23, 59, 59 , '-3')
  lot.deadline_3 = DateTime.new(2016, 3, 21, 2, 59, 59 , '-3')
  lot.deadline_4 = DateTime.new(2016, 4, 11, 23, 59, 59 , '-3')
end
lot1.save!

lot2 = Lot.new do |lot|
  lot.name = "Segundo lote"
  lot.number = 2
  lot.limit = 132
  lot.start_date = DateTime.new(2016, 1, 14, 0, 0, 0 , '-3')
  lot.end_date = DateTime.new(2016, 1, 16, 23, 59, 59 , '-3')
  lot.deadline_1 = DateTime.new(2016, 1, 25, 23, 59, 59 , '-3')
  lot.deadline_2 = DateTime.new(2016, 2, 22, 23, 59, 59 , '-3')
  lot.deadline_3 = DateTime.new(2016, 3, 21, 2, 59, 59 , '-3')
  lot.deadline_4 = DateTime.new(2016, 4, 11, 23, 59, 59 , '-3')
end
lot2.save!

lot3 = Lot.new do |lot|
  lot.name = "Terceiro lote"
  lot.number = 3
  lot.limit = 100
  lot.start_date = DateTime.new(2016, 1, 21, 0, 0, 0 , '-3')
  lot.end_date = DateTime.new(2016, 7, 31, 23, 59, 59 , '-3')
  lot.deadline_1 = DateTime.new(2016, 2, 1, 23, 59, 59 , '-3')
  lot.deadline_2 = DateTime.new(2016, 2, 29, 23, 59, 59 , '-3')
  lot.deadline_3 = DateTime.new(2016, 3, 28, 2, 59, 59 , '-3')
  lot.deadline_4 = DateTime.new(2016, 4, 18, 23, 59, 59 , '-3')
end
lot3.save!