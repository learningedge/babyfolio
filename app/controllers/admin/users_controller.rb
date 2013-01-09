class Admin::UsersController < Admin::ApplicationController

  def index
    conditions = Array.new

    if params[:search_term].present?
      conditions << "(users.first_name like ? OR users.last_name like ? OR users.email like ?)"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      @title = "Search results for \"#{params[:search_term]}\""
    end    

    params[:sort] ||= "users.email"

    if params[:see_all]
      @users = User.paginate :all, :page => params[:page], :per_page => 1000000, :order => params[:sort], :conditions => conditions
    else
      @users = User.paginate :page => params[:page], :order => params[:sort], :per_page => 20, :conditions => conditions
    end
  end

  def edit
    @user = User.find_by_id(params[:id])                
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])      
      redirect_to admin_users_path, :notice => "User successfully updated"
    else      
      render :action => 'edit'      
    end
  end

  def logs
    user = User.find(params[:user_id])
    @title = "Logs for #{user.email}"
    conditions = Array.new
    conditions << "logs.user_id = ?"
    conditions << user.id
    if params[:see_all]
      @logs = Log.paginate :all, :page => params[:page], :per_page => 1000000, :conditions => conditions, :order => "created_at DESC"
    else
      @logs = Log.paginate :page => params[:page], :per_page => 30, :conditions => conditions, :order => "created_at DESC"
    end
  end
end
