class Room < ActiveRecord::Base
  validates :hotel,
            presence: true,
            inclusion: { in: ["Jangadeiro", "Donana"], message: "não listado." }
  validates :number,
             uniqueness: { scope: :hotel, message: "Quarto já cadastrado nesse hotel." },
             numericality: { greater_than: 0, message: "Nº do quarto deve ser maior q zero." }
  validates :capacity,
             numericality: { greater_than: 0, message: "Capacidade deve ser maior que zero." }

  has_many :users

  def self.hotels
  	hotels = []
  	Room.all.each do |room|
  		hotel = room.hotel
  		hotels << hotel unless hotels.include?(hotel)
  	end
  end
end
