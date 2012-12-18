class ForgotPasswordsController < ApplicationController
  
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new    
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user      
      @user.reset_perishable_token!
      UserMailer.forgot_password(@user).deliver
      redirect_to reset_done_path
    else
      @error = "Sorry. No users found for given email."
      render :action => :new
    end  
  end

  def reset_done
  end

  def edit
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    @user.save_without_session_maintenance

    if @user.save      
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
