class Admin::DashboardController < Admin::ApplicationController

  layout "admin"

  def index
    
  end

  def search

    case params[:type]
    when "user" then
      redirect_to admin_users_path(:search_term => params[:search_term])
    when "family" then
      redirect_to admin_families_path(:search_term => params[:search_term])    
    end
    
  end

end
