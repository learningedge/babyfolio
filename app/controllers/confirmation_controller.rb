class ConfirmationController < ApplicationController

  before_filter :require_user

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
    @user = User.find_by_persistence_token @token
    @user.email_confirmed = 1
    @user.save
    redirect_to account_url
  end

end
