class FamiliesController < ApplicationController
  layout "child"
  before_filter :require_user

  def change_family
    set_current_family(params[:family_id])
    redirect_to settings_path
  end


  def make_admin      
      Relation.make_admin(params[:relation_id], current_user)    
      flash[:tab] = "family-friends-information";
      redirect_to settings_path
  end

  def remove_admin
      Relation.remove_admin(params[:relation_id], current_user)
      flash[:tab] = "family-friends-information";
      redirect_to settings_path
  end

  def remove_user      
      Relation.remove_from_family(params[:relation_id], current_user)    
      flash[:tab] = "family-friends-information";
      redirect_to settings_path
  end

  def edit_relation
    @relation = Relation.includes([[:child => :family], :user]).find_by_id(params[:relation_id])

    unless @relation.child.family.is_admin?(current_user)
      redirect_to settings_tab_path(:tab => "family-friends-information")
    end
  end

  def update_relation
    relation = Relation.includes([[:child => :family], :user]).find_by_id(params[:relation_id])
    display_name = params[:display_name].present? ? params[:display_name] : @relation.user.get_user_name
    is_admin = params[:is_admin]

    if relation.child.family.is_admin?(current_user)
      relations_to_update = relation.child.family.relations.find_all_by_user_id(relation.user_id)
      relations_to_update.each do |rel|
              rel.update_attributes({
                                     :display_name => display_name,
                                     :member_type => params[:relation_type],
                                     :is_admin => is_admin
                                   })
      end
    end

    redirect_to settings_tab_path(:tab => "family-friends-information")
  end

  def update_access
    access = params[:child_access] == "true" ? true : false
    Relation.update_access(access, params[:child_id], params[:user_id], current_user)
    render :text => "success"
  end

  def show_invitations_form
    @invitation_emails = []
    Relation::TYPE_KEYS.each do |k|
      @invitation_emails << {:email => '', :type => k, :error => nil }
    end

    respond_to do |format|
      format.html { render :partial => "families/invitations/invitations_form" }
    end
  end

  def invite_users
    @family = current_user.own_families.find_by_id(params[:family_id])
    types = params[:types]
    emails = params[:emails]    
    users = []    
    @error = false
    @invitation_emails = []

    @error = Family.check_invitation_emails(types, emails, @invitation_emails)    
    @error = @family.invite_users(@invitation_emails, users, current_user) if @error.blank?

    respond_to do |format|
      if @error.blank?
        users.each do |u|
          if u.save
            relation = u.relations.joins(:child).where("children.family_id" => @family.id).limit(1).first
            UserMailer.invite_user(relation, @family).deliver
          end
        end
        format.html { render :partial => 'families/invitations/invitations_sent' }
      else
        format.html { render :partial => "families/invitations/invitations_form" }
      end
    end

  end

  def resend_invitation
    relation = Relation.includes([:child => :family]).find_by_id(params[:relation_id])

    respond_to do |format|
      if relation.child.family.is_admin?(current_user)
        relation.update_attribute(:inviter_id, current_user.id)
        UserMailer.invite_user(relation, relation.child.family).deliver

        message = "Reminder has been sucessfully sent."
      else
        message = "There were some errors while send reminder, please try again later."
      end
      format.js { render :partial => "families/invitations/invitation_result", :locals => { :message => message, :dialog => '#confirm-resend-invite-dialog' }}
      
    end
  end

  def rescind_invitation
    relation = Relation.includes([:child => :family]).find_by_id(params[:relation_id])
    
    if relation.child.family.is_admin?(current_user)
      relations = relation.child.family.awaiting_relations.find_all_by_user_id(relation.user_id)
      relations.each do |rel|
        rel.destroy
      end
    end

    flash[:tab] = "family-friends-information";
    redirect_to settings_path
  end


end
