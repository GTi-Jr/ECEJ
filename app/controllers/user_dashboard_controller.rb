class UserDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :verify_register_conclusion
  #before_filter :verify_register_conclusion
  def index
  end

  protected

  #If you have extra params to permit, append them to the sanitizer.
  def verify_register_conclusion
    if !@user.is_completed
    	redirect_to after_registration_path(:personal_information)
    end
  end
  def get_user
  	@user = current_user
  end
end
