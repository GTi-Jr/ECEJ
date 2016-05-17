# Cria admin
admin = Crew::Admin.new do |admin|
  admin.name = "ECEJ"
  admin.email = "admin@admin.com"
  admin.confirmed_at = Time.now
  admin.confirmation_sent_at = Time.now
  if Rails.env.production?
    admin.password = 'senhadoadmin'
    admin.password_confirmation = 'senhadoadmin'
  else
    admin.password = "ecej2016"
    admin.password_confirmation = "ecej2016"
  end
end
admin.save!

hotel = Hotel.new do |hotel|
  hotel.name = "Um hotel 5 estrelas"
  hotel.extra_info = "Informação extra"
end
hotel.save!

# Cria lotes
lot1 = Lot.new do |lot|
  lot.name = "Primeiro lote"
  lot.number = 1
  lot.limit = 50
  lot.start_date = DateTime.new(2016, 1, 13, 20, 0, 0 , '-3')
  lot.end_date = DateTime.new(2016, 1, 14, 20, 0, 0 , '-3')
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
  lot.start_date = DateTime.new(2016, 1, 17, 20, 0, 0 , '-3')
  lot.end_date = DateTime.new(2016, 1, 19, 20, 0, 0 , '-3')
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
  lot.start_date = DateTime.new(2016, 1, 26, 20, 0, 0 , '-3')
  lot.end_date = DateTime.new(2016, 12, 31, 23, 59, 59 , '-3')
  lot.deadline_1 = DateTime.new(2016, 2, 1, 23, 59, 59 , '-3')
  lot.deadline_2 = DateTime.new(2016, 2, 29, 23, 59, 59 , '-3')
  lot.deadline_3 = DateTime.new(2016, 3, 28, 2, 59, 59 , '-3')
  lot.deadline_4 = DateTime.new(2016, 4, 18, 23, 59, 59 , '-3')
end
lot3.save!

# Cria usuário de teste
test_user = User.new do |user|
  user.name = 'Testador'
  user.email = 'testador@email.com'
  user.password = 'senhaecej'
  user.password_confirmation = 'senhaecej'
  user.confirmed_at = Time.now
  user.general_register = '0000000000000'
  user.cpf = '000.000.000-00'
  user.birthday = 20.years.ago
  user.gender = 'Masculino'
  user.phone = '(99) 99999-9999'
  user.federation = 'FEJECE'
  user.junior_enterprise = 'GTi Jr.'
  user.job = 'Gerente de projetos'
  user.university = 'Universidade Federal do Ceará'
  user.completed = true
  user.lot_id = 1
  user.state = 'CE'
  user.city = 'Fortaleza'
  user.street = 'Av. Washington Soares, 0000'
  user.cep = '00000-000'
end
test_user.payment = Payment.new method: 'PagSeguro'
test_user.payment.set_payment
test_user.payment.change_status :paid
test_user.save(validate: false)

(0...100).each do |i|
  random_user = User.new do |user|
    user.name = Faker::Name.name
    user.email = "#{Faker::Internet.safe_email(user.name)}"
    user.password = 'senhaecej'
    user.password_confirmation = 'senhaecej'
    user.confirmed_at = Time.now
    user.general_register = Faker::Number.number(11)
    user.cpf = CPF.generate(true)
    user.birthday = Faker::Date.between(17.years.ago, 26.years.ago)
    user.phone = Faker::PhoneNumber.phone_number
    user.federation = Faker::StarWars.specie
    user.junior_enterprise = Faker::Company.name
    user.job = Faker::Company.profession
    user.university = Faker::University.name
    user.completed = true
    user.state = Faker::Address.state
    user.city = Faker::Address.city
    user.street = Faker::Address.street_address
    user.cep = Faker::Address.zip

    loop do
      lot = Lot.find(Faker::Number.between(1,3))
      unless lot.is_full?
        user.lot = lot
        break
      end
    end

    if((Faker::Number.between(0, 10) % 2) == 0)
      n = Faker::Number.between(0,2)
      case n
      when 0
        user.payment = Payment.new method: 'PagSeguro'
      when 1
        user.payment = Payment.new method: 'Boleto'
      when 2
        user.payment = Payment.new method: 'Dinheiro'
      end

      user.payment.set_payment
      user.payment.change_status :paid
    end
  end
  random_user.save!
end
