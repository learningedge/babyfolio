class ConfirmationController < ApplicationController

  before_filter :require_user, :only => [:index, :re_send_email]

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
    if @user.nil?
      flash[:error] = "We can't find the user, try resending email"
      redirect_to confirmation_path
    else
      @user.email_confirmed = 1
      @user.save
      UserSession.create(@user)
      @user.reset_perishable_token!
      flash[:notice] = "Email successfuly confirmed."
      redirect_to new_family_url
    end
  end

#  def accept_invitation
#    @token = params[:token]
#    @user = User.find_by_perishable_token @token
#    UserSession.create(@user)
#  end
#
#  def update_user
#    params[:user][:email_confirmed] ||= 1
#    current_user.assign_attributes(params[:user])
#    current_user.reset_perishable_token!
#    if current_user.save
#      flash[:notice] = "Account details sucessfully updated."
#      redirect_to home_index_path
#    else
#      @user = current_user
#      render :accept_invitation
#    end
#  end


  def accept_invitation
    @token = params[:token]
    @relation = Relation.find_by_token(@token, :include => [:user])
    UserSession.create(@relation.user)
    session[:curent_family] = @relation.family_id
    rescue NoMethodError
      flash[:notice] = "Ooooooooops, there is something wrong with your invitation."
      redirect_to login_url
  end

  def update_user    
    @relation = Relation.find_by_token(params[:relation][:token])
    @relation.assign_attributes(params[:relation])    
    
    if @relation.save
      flash[:notice] = "Your settings has been sucessfully updated."
      @relation.user.update_attribute :email_confirmed, 1
      @relation.update_attribute :accepted, 1
      redirect_to child_profile_children_url
    else
      render :accept_invitation
    end
  end
  
end
