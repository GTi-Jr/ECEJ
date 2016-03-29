file = File.read("#{Rails.root}/lib/seeds/devs.csv")
people = CSV.parse(file)

people.each do |row|
  user = User.new do |user|
    user.name = row[0]
    user.email = row[1]
    user.password = 'developer'
    user.password_confirmation = 'developer'
    user.confirmed_at = DateTime.now
    user.confirmation_sent_at = DateTime.now
    user.active = true
    user.lot_id = 2
    user.payment = Payment.new do |payment|
      payment.method = "Dinheiro"
      payment.change_status :paid
    end
  end
  if user.save
    Rails.logger.info "#{user.name} foi adicionado"
  else
    Rails.logger.info "Não foi possível adicionar #{user.name}. Erros:\n\t #{user.errors.full_messages}"
  end
end
