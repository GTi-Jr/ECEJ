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
    User.where(lot_id: nil, active: true).order(:created_at)
  end
  def self.eligible
    User.where(active: true, completed: true, lot_id: nil).order(:created_at)
  end
  def self.allocated
    User.all.order(:created_at).select { |user| user.lot_id.is_a? Integer }
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

  # Insert users into groups
  def insert_into_disqualified_list!
    self.update_attribute(:active, false)
  end
  def insert_into_waiting_list!
    self.update_attribute(:lot_id, nil)
  end
  def insert_into_lot(lot)
    self.update_attribute(:lot_id, lot.id)
  end
  def insert_into_final_lot!
    self.update_attribute(:lot_id, 3) unless Lot.find(3).nil?
  end

  # METHODS USED IN THE SCHEDULED TASK
  # Call this method in the scheduled task
  def self.organize_lots!
    Lot.remove_overdue_users!
    User.insert_eligible_users_into_third_lot    
  end

  # Take those users who are eligible and, if the third lot has free slots,
  # insert them into it
  def self.insert_eligible_users_into_third_lot
    final_lot = Lot.find(3) unless Lot.find(3).nil?

    unless User.eligible.nil?
      User.eligible.each do |user|
        if final_lot.users.count < final_lot.limit && user.has_paid_in_time?
          user.insert_into_final_lot!
          UsersLotMailer.allocated_on_third_lot(user).deliver_now
        end
      end
    end
  end

  # Method called in the scheduler.rb to send emails
  # it only send the to the first lot.limit people in the eligible list
  def self.send_lot_2_antecipated_emails
    lot = Lot.find(2)
    User.eligible.first(lot.limit).each do |user|
      UsersLotMailer.send_antecipated_lot(user, lot).deliver_now
      Rails.logger.info "---- An email was sent to #{user.name}"
    end
  end

  # Method called in the scheduler.rb to send emails
  # it only send the to the first lot.limit people in the eligible list
  def self.send_lot_3_antecipated_emails
    lot = Lot.find(3)
    User.eligible.first(lot.limit).each do |user|
      UsersLotMailer.send_antecipated_lot(user, lot).deliver_now
      Rails.logger.info "---- An email was sent to #{user.name}"
    end
  end

end
