class HomeController < ApplicationController
  
  skip_before_filter :clear_family_registration
  skip_before_filter :require_confirmation
  

  def index
    @user_session = UserSession.new
  end

end
