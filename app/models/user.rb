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

  # checks if the user has confirmed within 15 days.
  def has_passed_15_days_since_creation?(user)
    (Time.now - user.created_at) > 15.days
  end

  # Scheduled task to inactivate users
  def self.delete_inactive_users!
    User.all.each do |user|
      unless user.is_completed? && user.has_paid?
        user.update_attribute(:active, false) if has_passed_15_days_since_creation?(user)
      end
    end
  end
  
end
