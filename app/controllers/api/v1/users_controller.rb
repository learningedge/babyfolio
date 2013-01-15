class Api::V1::UsersController < ApplicationController
  respond_to :json
  before_filter :require_user, :only => [:current]

  def current
    @user = current_user
    render :json => @user
  end

  def create
    @user = User.new(params[:user])      
    @user.reset_single_access_token
    @user.reset_perishable_token
    @user.profile_media = Media.find_by_id(params[:user_profile_media]) if params[:user_profile_media].present?
    
    if @user.valid?
      @user.email_confirmed = false
      @user.save      
      UserMailer.confirmation_email(@user).deliver

      message = "Your account has been created. Confirmation email has been sent."
      @status = true
    else
      @user.save!
      message = "There was a problem creating your account."
      @status = false
    end

    render :json => { :message => message, :success => @status }
  end

  

  def login    
    @user_session = UserSession.new(params[:user_session])    

    if @user_session.save
      @user_session.user.reset_perishable_token!
      session[:is_login] = nil

      Log.create_log(@user_session.user.id, ["Mobile user login successful!"])
      @status = true
    else
      @status = false
    end

    render :json => { :success => @status }
  end

  def logout
    Log.create_log(current_user.id, ["Mobile user logout successful!"])
    current_user_session.destroy
    reset_session
    render :json => { :success => true }
  end


end
