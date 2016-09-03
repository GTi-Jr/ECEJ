class Crew::Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  def new_user(user_params = {})
    @user = User.new(user_params)
    @user.active = true

    @user.payment = Payment.new(method: 'Dinheiro')
    @user.payment.change_status(:paid)

    @user.confirmation_sent_at = DateTime.now
    @user.confirmed_at = DateTime.now

    lot = Lot.active_lot

    @user.lot = lot if !lot.nil? && !lot.is_full?

    @user
  end

  def create_user(user_params = {})
    @user = new_user(user_params)

    password = Devise.friendly_token.first(8)
    @user.password = password

    saved = @user.save

    UserMailer.welcome(@user, password).deliver if saved

    saved
  end
end
