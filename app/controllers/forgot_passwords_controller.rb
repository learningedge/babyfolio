class ForgotPasswordsController < ApplicationController

  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new    
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      flash[:notice] = "Pleace check your email with proceed."
      @user.reset_perishable_token!
      UserMailer.forgot_password(@user).deliver
      redirect_to new_forgot_password_url
    else
      flash[:notice] = "We can't find user with email "+ params[:email]
      render :action => :new
    end  
  end

  def edit
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    @user.save_without_session_maintenance

    if @user.save
      flash[:success] = "Your password was successfully updated"
      redirect_to login_url
    else
      render :action => :edit
    end
  end

private
  
  def load_user_using_perishable_token
    @user = User.find_by_perishable_token params[:token]
    unless @user
      flash[:notice] = "We could not locate your account"
      redirect_to new_forgot_password_url
    end
  end
end
