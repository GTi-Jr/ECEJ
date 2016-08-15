admin = Crew::Admin.new(email: 'admin@sistemaalmej.com', password: 'sistemaalmej2016')

if admin.save
  p 'admin salvado'
else
  p "Não foi possível adicionar #{admin.email}. Erros:\n #{admin.errors.full_messages}"
end
