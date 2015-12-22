class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_one :address
  has_many :special_needs

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # Returns false unless the user has updated all of his information
  def is_completed?
    return false unless self.completed
    true
  end

  # Lots distributions
  #  ________________________________________________
  # |   Lot -1    |  Lot 0  |  Lot 1 | Lot 2 | Lot 3 |
  # |disqualified | Waiting |   50   |  150  |  100  |
  # |_____________|_________|________|_______|_______|
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
  def self.disqualified_list
    User.where(lot: -1).order("created_at")
  end

  # Insert users into lots
  def insert_into_disqualified_list!
    self.update_attribute(:lot, -1)
  end
  def insert_into_waiting_list!
    self.update_attribute(:lot, 0)
  end
  def insert_into_first_lot!
    self.update_attribute(:lot, 1)
  end
  def insert_into_second_lot!
    self.update_attribute(:lot, 2)
  end
  def insert_into_third_lot!
    self.update_attribute(:lot, 3)
  end

  # METHODS USED IN THE SCHEDULED TASK
  # Call this method in the scheduled task
  def self.organize_lots!
    today = Date.today
    

    User.delete_inactive_users!
    if today < 
    User.insert_inactive_users_into_disqualified_lot! 
  end

  # checks if the user has confirmed within 15 days.
  def has_passed_15_days_since_creation?
    (Time.now - self.created_at) > 15.days
  end

  # Method to inactivate users who hasn't qualified in 15 days.
  def self.insert_inactive_users_into_disqualified_lot!
    User.waiting_list.each do |user|
      unless user.is_completed? && user.has_paid?
        if user.has_passed_15_days_since_creation?
          user.insert_into_disqualified_list!
          Rails.logger.info "--- RETIRADO POR INATIVIDADE: #{user.name}"
        end
      end
    end
  end

  # Before calling this method, you MUST call User.delete_inactive_users!
  def self.insert_queued_users_into_first_lot!
    User.waiting_list.each do |user|
      user.insert_into_first_lot! unless User.first_lot.length > FIRST_LOT_SIZE
    end
  end
  # Before calling this method, you MUST call User.delete_inactive_users!
  def self.insert_queued_users_into_second_lot!
    User.waiting_list.each do |user|
      user.insert_into_first_lot! unless User.second_lot.length > SECOND_LOT_SIZE
    end
  end
  # Before calling this method, you MUST call User.delete_inactive_users!
  def self.insert_queued_users_into_third_lots!
    User.waiting_list.each do |user|
      user.insert_into_first_lot! unless User.first_lot.length > THIRD_LOT_SIZE
    end
  end

end
