class AfterRegistrationController < ApplicationController
  include Wicked::Wizard
  before_action :authenticate_user!
  before_action :get_user
  before_action :verify_register_conclusion

  layout "dashboard"
  steps :personal_information, :address_information, :mej_information

  def show
    @user.address = Address.new
    @user.completed = false
    render_wizard
  end

  def update
    case step
    when :personal_information
      @user.update_attributes(personal_params)
      render_wizard @user
    when :address_information
      @user.address.update_attributes(address_params)
      render_wizard @user
    when :mej_information
      @user.update_attributes(mej_params)
      @user.update_attribute(:completed,'true')
      sign_in(@user, bypass: true) # needed for devise
      redirect_to root_path
    end

  end


  protected
  def verify_register_conclusion
    if @user.is_completed?
    	redirect_to root_path
    end
  end

  private
  def personal_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:name, :general_register, :cpf, :birthday, :gender, :avatar, :phone, :special_needs)
  end
  def mej_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:federation, :junior_enterprise, :job, :university)
  end
  def address_params
    # NOTE: Using `strong_parameters` gem
    params.require(:address).permit(:city, :street, :postal_code, :complement)
  end
end
