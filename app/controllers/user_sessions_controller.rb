class UserSessionsController < ApplicationController

  before_filter :require_user, :only => [:destroy, :change_family]
  before_filter :clear_session, :only => [:create]
  skip_before_filter :require_confirmation

  def new
    @user_session = UserSession.new

    session[:is_login] = true
  end

  def create    
    @user_session = UserSession.new(params[:user_session])    

    if @user_session.save
      @user_session.user.reset_perishable_token!
      session[:is_login] = nil

      flash[:notice] = "Login successful!"
      Log.create_log(@user_session.user.id, ["User login successful!"])
      redirect_back_or_default child_profile_children_url
    else
      render :action => :new
      
    end
  end

  def change_family    
    session[:current_family] = params[:id]
    redirect_to :back
  end

  def destroy
    Log.create_log(current_user.id, ["User logout successful!"])
    current_user_session.destroy
    reset_session
    flash[:notice] = "Logout successful!"    
    redirect_back_or_default root_path
    
  end
end
