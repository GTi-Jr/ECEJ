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

# Eligible users
(1..5).each do |it|
  eligible_user = User.new do |user|
    user.name = "eligible_user_#{it}"
    user.email = "eligible_user_#{it}@email.com"
    user.confirmed_at = Time.now
    user.confirmation_sent_at = Time.now
    user.active = true
    user.completed = true
    user.confirmation_token = Devise.friendly_token
    user.password = "caiocaio"
    user.password_confirmation = "caiocaio"
  end
  eligible_user.save!
end

(1..5).each do |it|
  waiting_user = User.new do |user|
    user.name = "waiting_user_#{it}"
    user.email = "waiting_user_#{it}@email.com"
    user.confirmed_at = Time.now
    user.confirmation_sent_at = Time.now
    user.active = true
    user.confirmation_token = Devise.friendly_token
    user.password = "caiocaio"
    user.password_confirmation = "caiocaio"
  end
  waiting_user.save!
end

(1..3).each do |it|
  allocated_non_paying = User.new do |user|
    user.name = "allocated_non_paying_#{it}"
    user.email = "allocated_non_paying_#{it}@email.com"
    user.confirmed_at = Time.now
    user.confirmation_sent_at = Time.now
    user.active = true
    user.completed = true
    user.lot_id = 1
    user.confirmation_token = Devise.friendly_token
    user.password = "caiocaio"
    user.password_confirmation = "caiocaio"
  end
  allocated_non_paying.save!
end

(1..10).each do |it|
  allocated_paid = User.new do |user|
    user.name = "allocated_paid_#{it}"
    user.email = "allocated_paid_#{it}@email.com"
    user.confirmed_at = Time.now
    user.confirmation_sent_at = Time.now
    user.active = true
    user.completed = true
    user.lot_id = 1
    user.paid_on = DateTime.now
    user.confirmation_token = Devise.friendly_token
    user.password = "caiocaio"
    user.password_confirmation = "caiocaio"
  end
  allocated_paid.save!
end
