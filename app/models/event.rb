class Event < ActiveRecord::Base
  validates :name,
            presence: true
  validates :facilitator,
            presence: true
  validates :limit,
            presence: true
  validates :start,
            presence: true
  validates :end,
            presence: true
  validate :start_must_be_smaller_than_end

  has_many :subscriptions
  has_many :users, through: :subscriptions

  @@hours = 0..23

  # Returns all past events
  def self.past
    Event.select { |event| DateTime.now > event.end }
  end

  # Returns all future events
  def self.future
    Event.select { |event| DateTime.now < event.start}
  end

  # Returns all events tha are happening at the moment
  def self.happening
    now = DateTime.now
    Event.select { |event| now < event.end && now > event.start }
  end

  # Return an array of hashes with all the dates that have, at least, one event
  # and all of its events ordered by date.
  def self.days
    days  = []
    dates = []

    Event.all.each do |event|
      date = event.start.to_date

      unless date.in? dates
        days << { date: date, events: self.select { |event| event.start.to_date == date }.sort_by { |event| event.start } }
      end

      dates << date
    end

    days.sort_by { |day| day[:date] }
  end

  def occurring_days
    @days ||= (start.to_date)..(self.end.to_date)
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
    users.count >= limit
  end

  # Checks if the events is happening at the moment
  def is_happening_now?
    now = DateTime.now
    now > self.start && now < self.end
  end

  # Validator method
  def start_must_be_smaller_than_end
    errors.add(:start, "deve ser menor que a data de término") if self.start > self.end
  end
end
