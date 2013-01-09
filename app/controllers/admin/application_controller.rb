class Admin::ApplicationController < ApplicationController

  before_filter :require_admin
  layout "admin"

private
  def require_admin
    if !current_user
        store_location
        redirect_to login_url
        return false
    elsif !current_user.is_admin
        current_user_session.destroy
        reset_session
        store_location
        redirect_to login_url
        return false
    end
  end  
end
