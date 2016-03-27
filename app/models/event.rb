class Event < ActiveRecord::Base
  validates :name, 
            presence: true
  validates :facilitator,
            presence: true
  validates :limit,
            presence: true
  validates :start_time,
            presence: true
  validates :end_time,
            presence: true
  validate :start_must_be_smaller_than_end

  has_many :subscriptions
  has_many :users, through: :subscriptions

  # Returns all past events
  def self.past
    Event.select { |event| DateTime.now > event.end_time }
  end

  # Returns all future events
  def self.future
    Event.select { |event| DateTime.now < event.start_time }
  end

  # Returns all events tha are happening at the moment
  def self.happening
    now = DateTime.now
    Event.select { |event| now < event.end_time && now > event.start_time } 
  end

  # Return an array of hashes with all the dates that have, at least, one event 
  # and all of its events ordered by date.
  def self.days
    days = []
    Event.all.each do |event|
      date = event.start_time.to_date
      unless date.in? days
        days << { date: date, events: self.select { |event| event.start_time.to_date == date } }
      end
    end
    days.sort_by { |day| day[:date] }
  end

  # Add a user to the event
  def add(user)
    users << user
  end

  # Remove the user from the event
  def remove(user)
    users.delete user
  end

  # Checks if the event is full
  def full?
    users.count > limit
  end

  # Checks if the events is happening at the moment
  def is_happening_now?
    now = DateTime.now
    now > self.start_time && now < self.end
  end

  # Validator method
  def start_must_be_smaller_than_end
    errors.add(:start_time, "deve ser menor que a data de término") if self.start_time > self.end_time
  end
end
