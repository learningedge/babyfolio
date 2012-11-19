class HomeController < ApplicationController
  
  skip_before_filter :clear_family_registration
  skip_before_filter :require_confirmation
  
  def index
    redirect_to timeline_children_path if current_user
    @user_session = UserSession.new
  end

end
