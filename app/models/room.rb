class Room < ActiveRecord::Base
  validates :hotel,
            presence: true
  validates :number,
             uniqueness: { scope: :hotel, message: "Quarto já cadastrado nesse hotel." },
             numericality: { greater_than: 0, message: "Nº do quarto deve ser maior q zero." }
  validates :capacity,
             numericality: { greater_than: 0, message: "Capacidade deve ser maior que zero." }

  belongs_to :hotel
  has_many :users

  # Insert user into room
  def insert_user(user)
  	user.room = self
  	user.save!
  end

  # Remove user from room
  def remover_user(user)
  	user.room = nil
  	user.save!
  end

  def full?
  	self.users.count >= capacity
  end
end
