class ConfirmationController < ApplicationController

  before_filter :require_user, :only => [:index, :re_send_email, :confirm_email]

  def index
    @user = current_user
  end

  def re_send_email
    @user = current_user
    UserMailer.confirmation_email(@user).deliver
    render :index
  end

  def confirm_email
    @token = params[:token]
    @user = User.find_by_perishable_token @token
    @user.email_confirmed = 1
    @user.save
    @user.reset_perishable_token!
    redirect_to new_family_url
  end

  def accept_invitation
    @token = params[:token]
    @user = User.find_by_perishable_token @token
    UserSession.create(@user)   
  end

  def update_user
    params[:user][:email_confirmed] ||= 1
    current_user.assign_attributes(params[:user])    
    current_user.reset_perishable_token!
    if current_user.save
      flash[:notice] = "Account details sucessfully updated."
      redirect_to home_index_path
    else
      @user = current_user
      render :accept_invitation
    end
  end
  
end
