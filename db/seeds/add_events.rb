file = File.read("#{Rails.root}/lib/seeds/events.csv")
events = CSV.parse(file)

events.each do |row|
  event = Event.new do |event|
    event.name = row[0]
    event.facilitator = row[1]
    event.limit = row[2]
    event.start = row[3]
    event.end = row[4]
  end
  if event.save
    Rails.logger.info "#{event.name} foi adicionado"
  else
    Rails.logger.info "Não foi possível adicionar #{event.name}. Erros:\n\t #{event.errors.full_messages}"
  end
end
