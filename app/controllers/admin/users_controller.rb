class Admin::UsersController < Admin::ApplicationController

  def index

    conditions = Array.new

    conditions << "users.is_temporary = ?"
    conditions << false

    if params[:search_term]
      conditions[0] += " and (users.first_name like ? or users.last_name like ? or users.email like ?)"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      @title = "Search results for \"#{params[:search_term]}\""
    end
    
    params[:sort] ||= "users.email"

    if params[:see_all]
      @users = User.paginate :all, :page => params[:page], :per_page => 1000000, :order => params[:sort], :conditions => conditions
    else
      @users = User.paginate :page => params[:page], :order => params[:sort], :per_page => 10, :conditions => conditions
    end

  end

  def edit
    @user = User.find(params[:id])
    families = @user.families;
    @parenting_families = families.parenting_families
    @friend_families = families - @parenting_families
    
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])      
      redirect_to admin_users_path, :notice => "User was successfully updated"
    else      
      render :action => 'edit'      
    end
  end

end
