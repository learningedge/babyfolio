class Api::V1::SettingsController < ApplicationController
  before_filter :settings_vars
  layout false

  def info
  end

  def family
  end

  def invite
    @invitation_emails = []
    Relation::TYPE_KEYS.each do |k|
      @invitation_emails << {:email => '', :type => k, :error => nil }
    end
 
  end

  def f_and_f

  end


  private

  def settings_vars
    @page = Page.find_by_slug("settings")
    @very_own_family = current_user.get_first_very_own_family

    unless params[:is_about_me]
      @family = current_user.families.find_by_id(params[:family_id])
      @family = current_user.select_first_family unless @family
      @is_admin = @family.is_admin?(current_user)
      @is_family_admin = @very_own_family && @family.id == @very_own_family.id      
    else
      @family = @very_own_family
      @is_family_admin = true if @family
    end
   
    if @is_admin || @is_family_admin
      @children = current_user.children.where('children.family_id' => @family.id).all

      @family_admin_users = @family.admin_relations.includes(:user).where(['relations.user_id != ?', current_user.id]).uniq_by{|r| r.user.id}
      @family_member_users = @family.member_relations.includes(:user).where(['relations.user_id != ?', current_user.id]).uniq_by{|r| r.user.id}

      @children_access = {}
      (@family_admin_users.map{|r| r.user} + @family_member_users.map{|r| r.user}).uniq.each do |user|
        @children_access[user.id] = user.relations.joins(:child).where({"children.family_id" => @family.id}).all
      end

      @awaiting_family_invitations = @family.awaiting_relations.includes(:user).uniq_by{|r| r.user_id}
    end
    
    @all_children_relations = current_user.accessible_relations.includes([:child => :family]).where('relations.inviter_id IS NOT NULL').group_by{|r| r.child.family.name}
    @my_pending_invitations = current_user.relations.includes([:child, :user]).find_all_by_accepted(0).uniq_by{|r| r.child.family_id}
     
    @invitation_emails = []
    Relation::TYPE_KEYS.each do |k|
      @invitation_emails << {:email => '', :type => k, :error => nil }
    end
 


  end
   
 end
