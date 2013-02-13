class ConfirmationController < ApplicationController

#  skip_before_filter :require_confirmation
  before_filter :require_user, :only => [:index, :re_send_email]
#  before_filter :require_no_confirmation, :only => [:index, :re_send_email]

  def index
    @user = current_user
    UserMailer.confirmation_email(@user).deliver
  end

  def re_send_email
    @user = current_user
    UserMailer.confirmation_email(@user).deliver
    render :index
  end

  def confirm_email
#    @token = params[:token]
#    @user = User.find_by_persistence_token @token
#    if @user.nil?
#      flash[:error] = "We can't find the user, try resending email"
#      current_user_session.destroy if current_user_session
#      reset_session
#      redirect_to confirmation_path
#    else
#      @user.email_confirmed = 1
#      @user.save
#      UserSession.create(@user)
#      @user.reset_perishable_token!
#
#      redirect_to child_reflect_children_path
#    end
  end

  def email_confirmed
  end

  def accept_invitation    
    @relation = Relation.find_by_token(params[:token], :include => [:user, :inviter])
    @user = @relation.user
    @edit = true
    @edit_password = true
    reset_session
    UserSession.create(@relation.user)
    @user.update_attribute(:email_confirmed, true)
    unless current_user.is_temporary
      redirect_to confirmation_accept_relations_path
    end
    
    rescue NoMethodError      
      redirect_to login_url
  end

  def update_user
    @relation = Relation.find_by_token(params[:token], :include => [:user])
    @user = @relation.user
    @edit = true

    @user.profile_media = Media.find_by_id(params[:user_profile_media])
    params[:user][:is_temporary] = 0
    @user.assign_attributes(params[:user])
    @user.errors.add(:password, "can't be blank") if params[:user][:password].blank?

    if @user.errors.empty? && @user.save
        @user.user_actions.create(:title => "account_created")
        redirect_to confirmation_accept_relations_path
    else
        render :accept_invitation
    end
  end

  def accept_relations
    @relations = current_user.relations.includes([:child, :user]).find_all_by_accepted(0).uniq_by{|r| r.child.family_id}
  end

  def update_relation
    Relation.update_relation(params[:token], current_user, params[:accept].present?)
    count = Relation.count(:all, :conditions => ['user_id = ? AND accepted = 0', current_user.id])

    respond_to do |format|
        format.html { render :text => count }
    end
  end

end
