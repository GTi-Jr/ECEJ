file = File.read("#{Rails.root}/lib/seeds/almej_1.csv")
people = CSV.parse(file)
admin = Crew::Admin.new

people.each do |row|
  user = admin.new_user( { name: row[0], email: row[1] } )

  if user.save
    Rails.logger.info "#{user.name} foi adicionado"
  else
    Rails.logger.info "Não foi possível adicionar #{user.email}. Erros:\n #{user.errors.full_messages}"
  end
end
