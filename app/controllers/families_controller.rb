class FamiliesController < ApplicationController

  before_filter :require_user
  before_filter :require_confirmation
  before_filter :require_family, :only => [:add_friends, :create_friend_relations]

  def new
    @family = Family.new
    10.times {
      @family.children.build
    }
    @family.relations.build :user => User.new(:email => current_user.email), :member_type => 'parent'
    @family.relations.build :user => User.new, :member_type => 'parent'
  end

  def create
    parents_count = 2;
    @family = Family.new(params['family'])    
    @family.relations.first.user = current_user    
    @family.relations.first.user.reset_perishable_token
    @family.relations.first.user.reset_single_access_token
    second_parent = @family.relations.fetch(1).user
    if second_parent.email.empty?
      @family.relations.delete_at(1)
      parents_count -= 1
    else
      second_parent.reset_password
      second_parent.reset_perishable_token
      second_parent.reset_single_access_token
    end   
    
    respond_to do |format|
      if @family.save        
        if parents_count == 2
          second_relation = @family.relations.fetch(1)
          UserMailer.invite_user(second_relation.user, second_relation.member_type).deliver
        end
        
        flash[:notice] = 'Family has been successfully created.'
        session[:current_family] = @family.id
        format.html { redirect_to add_friends_families_path }
        format.xml  { render :xml => @family, :status => :created, :location => @family }
        
      else
        @family.relations.first.user = User.new(:email => current_user.email)
        @family.relations.build(:user => User.new, :member_type => 'parent') if @family.relations.length == 1

        while @family.children.length < 10 do
          @family.children << Child.new
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
      end
    end
  end

  def add_friends
    
  end

  def create_friend_relations

    @family = current_family
    @friends = params[:friends]
    user_emails = Array.new
    users = Array.new
    @error = false

    @friends.each do |friend|
      user_email = friend[1][:email].strip
      unless  user_email == "";
        unless user_emails.include?(user_email)
          user_emails << user_email
        else
          @error = true
          break
        end
      end
    end

    unless @error
      exist_users = User.where(['email IN (?)', user_emails]).all
      exist_users.each do |exist_user|
        unless exist_user.families.empty?
          exist_user.families.each do |family|
            if family == @family
             @error = true
            end
          end
        end
      end
    end

    unless @error

      @friends.each do |friend|
        unless friend[1][:email].strip == ""

          @user_exist = false
          
          exist_users.each do |exist_user|
            if exist_user.email == friend[1][:email]
              @user = exist_user
              @user_exist = true
              break
            end
          end

          unless @user_exist
            @user = User.new(:email => friend[1][:email])
            @user.reset_password
            @user.reset_perishable_token
            @user.reset_single_access_token
          end

          @user.relations.build :member_type => friend[1][:member_type], :family_id => @family.id
          
          unless @user.valid?
            @error = true
            break
          else
            users << @user
          end
        end
      end
      unless @error
        users.each do |user|
          user.save
          UserMailer.invite_user(user, user.relations.where(["family_id = ?",@family.id]).first.member_type).delivery
        end
        flash[:notice] = "Congrats you send emails to your friends :D!!"
        redirect_to add_friends_families_url
      else
        flash[:notice] = "Invalid emails!"
        render :action => :add_friends
      end
    else
      flash[:notice] = "Sorry one of the email you wrote is exist in your family"
      render :action => :add_friends
    end
  end

  private

    def require_family
      redirect_to new_family_url unless current_family
    end
    
    def require_no_family
      redirect_to new_family_url if current_family
    end



end
