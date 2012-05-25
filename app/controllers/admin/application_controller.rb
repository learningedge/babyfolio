class Admin::ApplicationController < ApplicationController

  skip_before_filter :require_confirmation
  before_filter :require_admin
  layout "admin"

private
  def require_admin
    if !current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
        return false
    elsif !current_user.is_admin
        current_user_session.destroy
        reset_session
        store_location
        flash[:notice] = "You must be logged in as admin to access this page"
        redirect_to login_url
        return false
    end
  end  
end
