class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_one :address
  has_many :special_needs

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def is_completed?
    return false unless self.completed
    true
  end

  # Distribuição de lotes
  # Lote 0: Fila de espera
  # Lote 1: 50
  # Lote 2: 150
  # lote 3: 100
  
  def self.first_lot
    User.where(lot: 1).order("created_at")
  end

  def self.second_lot
    User.where(lot: 2).order("created_at")
  end

  def self.third_lot
    User.where(lot: 3).order("created_at")
  end

  def self.waiting_list 
    User.where(lot: 0).order("created_at")
  end

  # Insert users into lists
  def insert_into_waiting_list
    self.update_attribute(:lot, 0)
  end

  def insert_into_first_lot
    self.update_attribute(:lot, 1)
  end

  def insert_into_second_lot
    self.update_attribute(:lot, 2)
  end

  def insert_into_third_lot
    self.update_attribute(:lot, 3)
  end


  # checks if the user has confirmed within 15 days.
  def has_passed_15_days_since_creation?
    (Time.now - self.created_at) > 15.days
  end

  # Scheduled task to inactivate users.
  def self.delete_inactive_users!
    User.all.each do |user|
      unless user.is_completed? && user.has_paid?
        user.update_attribute(:active, false) if user.has_passed_15_days_since_creation?
        Rails.logger.info "--- RETIRADO POR INATIVIDADE: #{user.name}" unless user.active
      end
    end
  end

  # List of those people who's confirmed into the main event.
  def self.priority_list
    User.where(active: true)
  end

  def self.insert_into_priority_list
    
  end
  
end
