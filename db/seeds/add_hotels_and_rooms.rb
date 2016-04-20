hotels_file = File.read("#{Rails.root}/lib/seeds/hotels.csv")
hotels = CSV.parse(hotels_file)
rooms_file = File.read("#{Rails.root}/lib/seeds/rooms.csv")
rooms = CSV.parse(rooms_file)

hotels.each do |row|
  hotel = Hotel.new do |hotel|
    hotel.name = row[0]
    hotel.extra_info = row[1]
    rooms.each do |row|
      room = Room.new do |room|
        room.number = row[0]
        room.capacity = row[1]
        room.extra_info = row[2]
        room.name = row[3]
      end
      hotel.rooms << room
    end
  end
  if hotel.save
    Rails.logger.info "#{hotel.name} foi adicionado"
  else
    Rails.logger.info "Não foi possível adicionar #{hotel.name}. Erros:\n\t #{hotel.errors.full_messages}"
  end
end
