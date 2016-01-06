class UserDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :verify_register_conclusion

  layout "dashboard"
  
  def index
  end

end
