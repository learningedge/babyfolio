class Admin::DashboardController < Admin::ApplicationController

  layout "admin"

  
  def index    
  end

  def search
    case params[:type]
    when "user" then
      redirect_to admin_users_path(:search_term => params[:search_term])
    when "page" then
      redirect_to admin_pages_path(:search_term => params[:search_term])
    when "activity" then
      redirect_to admin_activities_path(:search_term => params[:search_term])
    when "behaviour" then
      redirect_to admin_behaviours_path(:search_term => params[:search_term])
    end
    
  end

end
