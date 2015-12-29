class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  belongs_to :lot
  has_one :address
  mount_uploader :avatar, AvatarUploader
  # Returns false unless the user has updated all of his information
  def is_completed?
    return false unless self.completed
    true
  end

  # Lists
  def self.disqualified
    User.where(active: false).order(:created_at)
  end
  def self.waiting_list
    User.where(lot_id: nil, active: nil).order(:created_at)
  end
  def self.eligible
    User.where(completed: true).order(:created_at)
  end
  def self.allocated
    User.all.order(:created_at).select { |user| user.lot_id.is_a? Integer }
  end

  # Insert users into groups
  def insert_into_disqualified_list!
    self.update_attribute(:active, false)
  end
  def insert_into_waiting_list!
    self.update_attribute(:lot_id, nil)
  end
  def insert_into_active_lot!
    self.update_attribute(:lot_id, Lot.active_lot.id) unless Lot.active_lot.nil?
  end

  # METHODS USED IN THE SCHEDULED TASK
  # Call this method in the scheduled task
  def self.organize_lots!
    final_lot = Lot.find(3)
    # Take those user in the waiting list who hasn't completed
    User.insert_inactive_users_into_disqualified_lot! 
    Lot.remove_overdue_users!

    User.eligible.each do |user|
      if Lot.active_lot.users.count <= Lot.active_lot.limit && user.has_paid_in_time?
        user.insert_into_active_lot!
      else
        user.insert_into_waiting_list
      end
    end
  end

  # checks if the user has confirmed within 15 days.
  def has_passed_15_days_since_creation?
    (Time.now - self.created_at) > 15.days
  end

  # This checking is possible since paid_on's default value is nil.
  def has_paid?
    return self.paid_on ? true : false
  end

  # Checks if the user has paid within their respective lot deadline
  def has_paid_in_time?
    if self.has_paid?
      if self.paid_on.to_date > self.lot.payment_deadline
        return false
      else
        return true
      end
    else
      return false
    end
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

end
