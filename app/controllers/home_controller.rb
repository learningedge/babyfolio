class HomeController < ApplicationController

  layout 'child', :only => :about
  skip_before_filter :clear_family_registration
  skip_before_filter :require_confirmation
  
  def index
#    redirect_to child_reflect_children_path if current_user
    redirect_to show_timeline_path if current_user
    @user_session = UserSession.new
  end

  def about
  end

end
