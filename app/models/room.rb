class Room < ActiveRecord::Base
  validates :number,
             uniqueness: { scope: :hotel, message: "Quarto já cadastrado nesse hotel." },
             numericality: { greater_than: 0, message: "deve ser maior que zero." }
  validates :capacity,
             numericality: { greater_than: 0, message: "deve ser maior que zero." }

  belongs_to :hotel
  has_many :users

  # Insert user into room
  def insert_user(user)
  	user.room = self
  	user.save!
  end

  # Remove user from room
  def remove_user(user)
  	user.room = nil
  	user.save!
  end

  def full?
  	self.users.count >= capacity
  end

  def image_url
    hotel.room_image_url
  end

  # OVERRIDE
  def to_s
    "#{number} | #{hotel}"
  end
end
