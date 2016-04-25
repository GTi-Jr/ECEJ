class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  usar_como_cpf :cpf
  has_one :payment
  has_many :subscriptions
  has_many :events, through: :subscriptions

  belongs_to :room
  belongs_to :lot

  has_one :address

  mount_uploader :avatar, AvatarUploader

  # The -> operator is equivalent to lambda
  scope :disqualified, -> { where(active: false).order(:created_at) }
  scope :waiting_list, -> { where(lot_id: nil, active: nil, completed: false).order(:created_at) }
  scope :eligible, -> { where(active: true, completed: true, lot_id: nil).order(:created_at) }
  scope :allocated, -> { order(:created_at).select { |user| user.lot_id.is_a? Integer } }

  # TODO Remove those methods when the project is completed and the ECEJ event has ended
  # Get attributes from addres string
  def city1
    addres ? addres.split(',')[0].lstrip : nil
  end

  def cep1
    addres ? addres.split(',')[1].lstrip : nil
  end

  def street1
    addres ? addres.split(',')[2].lstrip : nil
  end

  def complement
    addres ? addres.split(',')[3].lstrip : nil
  end
  # end of attributes

  # Returns the user's first name
  def first_name
    name.split(' ').first
  end

  # Returns the user's last name
  def last_name
    name.split(' ').last
  end

  # Returns the first and last name
  # user.name = "Bruce Freaking Dickinson"
  # user.two_names #=> "Bruce Dickinson"
  def two_names
    name.split(' ').length == 1 ? first_name : "#{first_name} #{last_name}"
  end

  # Returns true if there's anything in federation.
  def is_fed?
    !federation.nil? || !federation.empty?
  end

  # Returns false unless the user has updated all of his information
  def is_completed?
    return false unless self.completed
    true
  end

  # Generates a CSV from all users
  # To add any param to the CSV just do
  # csv_attributes << user.attribute
  def self.to_csv
    CSV.generate do |csv|
      csv << ['Nome', "Telefone"]
      all.each do |user|
        csv_attributes = [user.name, user.phone]
        csv << csv_attributes
      end
    end
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

  # Checks if the user has another event that is happening at the same time
  def has_concurrent_event?(event)
    events.each do |user_event|
      # By default, event.start must be greater than event.end.
      # Condition for the event not being concurrent
      condition = (user_event.end < event.start) ||
                  (user_event.end.strftime('%Y/%m/%d %H:%M:%S') == event.start.strftime('%Y/%m/%d %H:%M:%S')) ||
                  (user_event.start > event.end) ||
                  (user_event.start.strftime('%Y/%m/%d %H:%M:%S') == event.end.strftime('%Y/%m/%d %H:%M:%S'))
      p "#{event.name}: #{condition}"
      p "#{(user_event.end < event.start)}: (#{user_event.end} < #{event.start})"
      p "#{(user_event.end.strftime('%Y/%m/%d %H:%M:%S') == event.start.strftime('%Y/%m/%d %H:%M:%S'))}: (#{user_event.end.strftime('%Y/%m/%d %H:%M:%S')} == #{event.start.strftime('%Y/%m/%d %H:%M:%S')})"
      p "#{(user_event.start > event.end)}: (#{user_event.start} > #{event.end})"
      p "#{(user_event.start.strftime('%Y/%m/%d %H:%M:%S') == event.end.strftime('%Y/%m/%d %H:%M:%S'))}: (#{user_event.start.strftime('%Y/%m/%d %H:%M:%S')} == #{event.end.strftime('%Y/%m/%d %H:%M:%S')})"
      if condition
        user_event.equivalents.each do |eq|
          p "EQ: #{eq.name}"
          p "1111111 + #{event.name}" unless (eq.end <= event.start) ||
                             (eq.end.strftime('%Y/%m/%d %H:%M:%S') == event.start.strftime('%Y/%m/%d %H:%M:%S')) ||
                             (eq.start >= event.end) ||
                             (eq.start.strftime('%Y/%m/%d %H:%M:%S') == event.end.strftime('%Y/%m/%d %H:%M:%S'))
          return true unless (eq.end <= event.start) || 
                             (eq.end.strftime('%Y/%m/%d %H:%M:%S') == event.start.strftime('%Y/%m/%d %H:%M:%S')) ||
                             (eq.start >= event.end) ||
                             (eq.start.strftime('%Y/%m/%d %H:%M:%S') == event.end.strftime('%Y/%m/%d %H:%M:%S'))

        end
      end
        
      return true unless condition
    end
    false
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

  # Disqualify user
  def disqualify
    self.active = false

    if !self.lot.nil?
      if User.eligible.any?
        allocated_user = User.eligible.first
        allocated_user.update_attributes lot_id: lot.id

        UsersLotMailer.allocated(allocated_user)
      end
      self.lot = nil
    end
    save
  end

  def change_position_with(user)
    auxiliar_lot = lot
    self.lot = user.lot
    user.lot = auxiliar_lot
    save && user.save
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

  def self.ask_to_choose_payment_method
    User.allocated.each do |user|
      UsersLotMailer.choose_payment(user).deliver_now
    end
  end

  # Exit room
  def exit_room!
    self.room = nil
    self.save
  end
end
