class Admin::UsersController < Admin::ApplicationController

  def index
    if params[:see_all]
      @users = User.paginate :all, :page => params[:page], :per_page => 1000000, :order => params[:sort]
    else
      @users = User.paginate :page => params[:page], :order => params[:sort], :per_page => 10
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])      
      redirect_to admin_users_path, :notice => "User was successfully updated"
    else
      response_to do |format|
        format.html { render :action => 'edit' }
      end
    end
  end

end
