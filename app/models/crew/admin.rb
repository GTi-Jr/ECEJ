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

    password = @user.cpf.only_numbers # "123.456.789-00" #=> "12345678900"

    @user.password = password
    @user.password_confirmation = password

    lot = Lot.active_lot

    @user.lot = lot if !lot.nil? && !lot.is_full?

    @user
  end

  def create_user(user_params = {})
    @user = new_user(user_params)
    @user.save
  end
end
