class Room < ActiveRecord::Base
  validate :hotel,
            exclusion: { in: %w(Jangadeiro Donana) }
  validate :number,
           uniqueness: { scope: :hotel },
           numericality: { greater_than: 0 }
  validate :number,
           numericality: { greater_than: 0 }
end
