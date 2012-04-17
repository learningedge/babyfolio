class UserSessionsController < ApplicationController
#  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy, :change_family]
  before_filter :clear_session, :only => [:create]

  def new
#    current_user_session.destroy if current_user?
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      @user_session.user.reset_perishable_token!

      flash[:notice] = "Login successful!"
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
    current_user_session.destroy
    reset_session
    flash[:notice] = "Logout successful!"
    redirect_back_or_default login_path
    
  end
end
