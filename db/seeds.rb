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
  admin.password = ENV["ADMIN_PW"]
  admin.password_confirmation = ENV["ADMIN_PW"]
end

admin.save!

lot = Lot.new do |lot|
  lot.name = "nome do lot"
  lot.number = 1
  lot.limit = 100
  lot.value_federated = 350
  lot.value_not_federated = 400
  lot.start_date = Time.now
  lot.end_date = Time.now.tomorrow
end
lot.save!

user_disqualified = User.new do |user|
  user.name = "Desqualificado"
  user.email = "desq@email.com"
  user.lot_id = nil
  user.active = nil
  user.created_at = Time.now - 16.days
  user.confirmed_at = Time.now - 16.days
  user.confirmation_sent_at = Time.now - 16.days
  user.password = "caiocaio"
  user.password_confirmation = "caiocaio"
end
user_disqualified.save!

user_disqualified2 = User.new do |user|
  user.name = "Desqualificado 2"
  user.email = "desq2@email.com"
  user.lot_id = nil
  user.active = nil
  user.created_at = Time.now - 16.days
  user.confirmed_at = Time.now - 16.days
  user.confirmation_sent_at = Time.now - 16.days
  user.password = "caiocaio"
  user.password_confirmation = "caiocaio"
end
user_disqualified2.save!

user_waiting = User.new do |user|
  user.name = "Espera"
  user.email = "esp@email.com"
  user.lot_id = nil
  user.active = nil
  user.created_at = Time.now - 5.days
  user.confirmed_at = Time.now - 5.days
  user.confirmation_sent_at = Time.now - 5.days
  user.password = "caiocaio"
  user.password_confirmation = "caiocaio"
end
user_waiting.save!

user_active = User.new do |user|
  user.name = "Ativo"
  user.email = "ativo@email.com"
  user.completed = true
  user.lot_id = nil
  user.active = nil
  user.created_at = Time.now - 10.days
  user.confirmed_at = Time.now - 10.days
  user.confirmation_sent_at = Time.now - 10.days
  user.password = "caiocaio"
  user.password_confirmation = "caiocaio"
end
user_waiting.save!
user_active.insert_into_active_lot!

