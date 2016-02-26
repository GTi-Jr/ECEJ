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

  def start_must_be_smaller_than_end
    errors.add(:start, "deve ser menor que a data de término") if self.start > self.end
  end

  def is_happening_now?
    now = DateTime.now
    now > self.start && now < self.end
  end

  def self.past
    Event.select { |event| DateTime.now > event.end }
  end

  def self.future
    Event.select { |event| DateTime.now < event.start }
  end

  def self.happening
    now = DateTime.now
    Event.select { |event| now < event.end && now > event.start } 
  end

end
