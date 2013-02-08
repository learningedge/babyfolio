class RelationsController < ApplicationController

  before_filter :require_user
  before_filter :require_child 

  def destroy
    @relation = Relation::find(params[:id])
    @relation.delete

    redirect_to :back
  end

  def new
#    user = User.new
#    respond_to do |format|
#      format.html { render :partial => "add_relation_form", :locals => {:user => user} }
#    end
  end

  def create
#    user = User.find_or_initialize_by_email(params[:user][:email], :first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :is_temporary => true, :email_confirmed => false)
#
#    if user.new_record?
#      user.reset_password
#      user.reset_single_access_token
#      user.reset_perishable_token
#    end
#
#
#    user.relations.find_or_initialize_by_child_id(current_child.id, :member_type => params[:relation_type], :token => user.perishable_token, :inviter => current_user, :is_admin => params[:is_admin], :accepted => false)
#    user.reset_perishable_token
#
#
#    respond_to do |format|
#      if user.save
#        UserMailer.invite_user(user.relations.find_by_child_id(current_child.id), current_user).deliver
#        format.js { render :partial => 'relation_added'}
#      else
#        format.html { render :partial => 'add_relation_form', :locals => {:user => user}}
#      end
#    end
  end

  def show_invitations_form
    @invitation_emails = []
    Relation::TYPE_KEYS.each do |k|
      @invitation_emails << {:email => '', :type => k, :error => nil }
    end

    respond_to do |format|
      format.html { render :partial => "invitations_form" }
    end
  end

  def invite_users
    types = params[:types]
    emails = params[:emails]
    users = []
    @error = false
    @invitation_emails = []

    
    types.each_with_index do |t, idx|
      item = { :email => emails[idx].strip, :type => t, :error => nil }
      if item[:email].present? && !item[:email].match(/^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i)
        item[:error] = "should look like an email address"
        @error = "Invalid email address entered"
      end
      @invitation_emails << item
    end
    @error = "No email addresses entered" unless emails.any? { |e| e.present? }
    
    
    if @error.blank?
      @invitation_emails.select{|ie| ie[:email].present? && ie[:error].blank?}.each do |ie|
        user = User.find_or_initialize_by_email(ie[:email], :is_temporary => true, :email_confirmed => false)

        if user.new_record?
          user.reset_password
          user.reset_single_access_token
          user.reset_perishable_token
        end

        rel = user.relations.find_or_initialize_by_child_id(current_child.id, :member_type => ie[:type], :token => user.perishable_token, :inviter => current_user, :is_admin => false, :accepted => false)
        user.reset_perishable_token

        unless rel.new_record?
          ie[:error] = "user already invited"
          @error = "User have been already invited"
        else
          users << user
        end        
      end          
    end

    respond_to do |format|
      if @error.blank?
        users.each do |u|
          if u.save
            relation = u.relations.find_by_child_id(current_child.id)
            UserMailer.invite_user(relation).deliver
          end
        end
        format.html { render :partial => 'invitations_sent' }
      else
        format.html { render :partial => "invitations_form" }
      end
    end
    
  end

  def make_admin
    rel = Relation.find_by_id_and_inviter_id(params[:relation_id], current_user.id)
    if rel
      rel.update_attribute(:is_admin, true)
    else
      flash[:notice] = "Couldn't find given realtion"
    end
    redirect_to settings_path
  end
  
end
