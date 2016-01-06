class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  #If you have extra params to permit, append them to the sanitizer.
  def verify_register_conclusion
    if !@user.is_completed?
    	redirect_to after_registration_path(:personal_information)
    end
  end
  helper_method :check_and_redirect

  def get_user
  	@user = current_user
  end

  def determine_layout
    current_user.nil? ? "login" : "dashboard"
  end
  
end
