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

  def start_must_be_smaller_than_end
    errors.add(:start_time, "deve ser menor que a data de término") if self.start_time > self.end_time
  end

  def is_happening_now?
    now = DateTime.now
    now > self.start_time && now < self.end
  end

  def self.past
    Event.select { |event| DateTime.now > event.end_time }
  end

  def self.future
    Event.select { |event| DateTime.now < event.start_time }
  end

  def self.happening
    now = DateTime.now
    Event.select { |event| now < event.end_time && now > event.start_time } 
  end

  def self.days
    days = []
    Event.all.each do |event|
      date = event.start_time.to_date
      days << date unless days.include?(date)
    end
    days.sort
  end

end
