lot = Lot.new(
  name: 'Único',
  number: 1,
  limit: 5_000,
  value_not_federated: 0,
  value_federated: 0,
  start_date: DateTime.new(2016, 1, 1, 0, 0, 0, '-3'),
  end_date: DateTime.new(2017, 1, 1, 0, 0, 0, '-3'),
)

if lot.save
  puts 'Lote registrado com sucesso.'
else
  p 'deu ruim'
  p lot.errors.full_messages
end
