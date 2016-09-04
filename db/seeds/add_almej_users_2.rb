file = File.read("#{Rails.root}/lib/seeds/almej_2.csv")
people = CSV.parse(file)
admin = Crew::Admin.new

people.each do |row|
  user = admin.new_user( { name: row[0], email: row[1] } )

  password = Devise.friendly_token.first(8)
  user.password = password
  user.password_confirmation = password


  if user.save
    p "#{user.name} foi adicionado"
    UserMailer.welcome(user, password).deliver
  else
    p "Não foi possível adicionar #{user.email}. Erros:\n #{user.errors.full_messages}"
  end
end
