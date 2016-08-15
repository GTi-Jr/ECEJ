admin = Crew::Admin.new(
  name: 'ALMEJ 2016',
  email: 'admin@sistemaalmej.com',
  password: 'sistemaalmej2016',
  password_confirmation: 'sistemaalmej2016',
  confirmed_at: Time.now,
  confirmation_sent_at: Time.now
)

if admin.save
  p 'admin salvado'
else
  p "Não foi possível adicionar #{admin.email}. Erros:\n #{admin.errors.full_messages}"
end
