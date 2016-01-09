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
  admin.password = "caiocaio"#ENV['ADMIN_PW']
  admin.password_confirmation = "caiocaio"#ENV['ADMIN_PW']
end
admin.save!

lot1 = Lot.new do |lot|
  lot.name = "Primeiro lote"
  lot.number = 1
  lot.limit = 50
  lot.value_not_federated = 385
  lot.value_federated = 395
  lot.start_date = DateTime.new(2016, 1, 10, 0, 0, 0 , '-3')
  lot.end_date = DateTime.new(2016, 1, 11, 23, 59, 59 , '-3')
  lot.payment_deadline = DateTime.new(2016, 1, 25, 23, 59, 59 , '-3')
end
lot1.save!

lot2 = Lot.new do |lot|
  lot.name = "Segundo lote"
  lot.number = 2
  lot.limit = 132
  lot.value_not_federated = 395
  lot.value_federated = 405
  lot.start_date = DateTime.new(2016, 1, 14, 0, 0, 0 , '-3')
  lot.end_date = DateTime.new(2016, 1, 16, 23, 59, 59 , '-3')
  lot.payment_deadline = DateTime.new(2016, 1, 25, 23, 59, 59 , '-3')
end
lot2.save!

lot3 = Lot.new do |lot|
  lot.name = "Terceiro lote"
  lot.number = 3
  lot.limit = 100
  lot.value_not_federated = 400
  lot.value_federated = 410
  lot.start_date = DateTime.new(2016, 1, 21, 0, 0, 0 , '-3')
  lot.end_date = DateTime.new(2016, 7, 31, 23, 59, 59 , '-3')
  lot.payment_deadline = DateTime.new(2016, 1, 31, 23, 59, 59 , '-3')
end
lot3.save!

