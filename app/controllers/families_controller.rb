class FamiliesController < ApplicationController

  before_filter :require_user
  before_filter :require_confirmation
  before_filter :require_my_family, :only => [:add_friends, :create_friend_relations, :create_friends, :relations, :create_relations, :show, :edit, :update, :family_relations_info]

  def index
    @family = current_family
    #    render :text => @family.relations.length
  end

  def new

    flash[:registration] = true;

    @family = Family.new
    10.times {
      @family.children.build
    }
    @family.relations.build :user => User.new(:email => current_user.email), :member_type => 'parent'
    @family.relations.build :user => User.new, :member_type => 'parent'
  end

  def create

    flash[:registration] = flash[:registration]

    parents_count = 2;
    @family = Family.new(params['family'])
    @family.relations.first.token = current_user.perishable_token
    @family.relations.first.accepted = 1
    current_user.reset_perishable_token
    @family.relations.first.user = current_user    
    @family.relations.first.user.reset_perishable_token
    @family.relations.first.user.reset_single_access_token
    second_parent = @family.relations.fetch(1)
    if second_parent.user.email.empty?
      @family.relations.delete_at(1)
      parents_count -= 1
    else
      unless User.where(:email => second_parent.user.email).exists?
        second_parent.user.reset_password
        second_parent.user.reset_perishable_token
        second_parent.user.reset_single_access_token
      else
        second_parent.user = User.find_by_email second_parent.user.email
      end
      second_parent.token = second_parent.user.perishable_token
      second_parent.accepted = 0
      second_parent.user.reset_perishable_token
    end   
    
    respond_to do |format|
      if @family.save        
        if parents_count == 2
          second_relation = @family.relations.fetch(1)
          UserMailer.invite_user(second_relation , current_user).deliver

        end
        
        flash[:notice] = 'Family has been successfully created.'
        session[:current_family] = @family.id
        format.html { redirect_to add_friends_families_path }
        format.xml  { render :xml => @family, :status => :created, :location => @family }
        
      else
        @family.relations.first.user = User.new(:email => current_user.email)
        @family.relations.build(:user => User.new, :member_type => 'parent') if @family.relations.length == 1

        while @family.children.length < 10 do
          @family.children.build Child.new.attributes
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
      end
    end
  end

  def change_family_to_edit
    session[:current_family] = params[:id]
    redirect_to :back
  end

  def edit        
    @family = my_family
    while @family.children.length < 10 do
      @family.children.build Child.new.attributes
    end
  end

  def update
    @family = current_user.families.parenting_families.includes(:children).find(my_family.id)
    if @family.update_attributes(params[:family])
      flash[:notice] = 'Family successfully updated.'
      redirect_to edit_families_path
    else
      render :action => 'edit'
    end
  end 

  def add_friends
    flash[:registration] = flash[:registration]
  end

  def create_friend_relations
    flash[:registration] = flash[:registration]
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
          @flash_error = "Sorry one of the email you wrote is exist in your family";
          break
        end
      end
    end

    if user_emails.empty?
      @error = true 
      @flash_error = "You can't invite no one";
    end

    unless @error
      exist_users = User.where(['email IN (?)', user_emails]).all
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


          unless @user.valid?
              @error = true
              break
          end

          user_relation = @user.relations.where(:family_id => @family.id).first

          if user_relation.nil?
            @user.relations.build :member_type => friend[1][:member_type], :family_id => @family.id, :token => @user.perishable_token
          else
            user_relation.update_attribute(:token, @user.perishable_token)
          end

          @user.reset_perishable_token
          users << @user

        end
      end

      unless @error
        users.each do |user|
          user.save
          UserMailer.invite_user(user.relations.where(["family_id = ?",@family.id]).first, current_user).deliver
        end
        flash[:notice] = "Thanks fo inviting others. We have successfully sent emails to the other family & friends that you entered."
        redirect_to child_profile_children_url
      else
        flash[:error] = "Invalid emails!"
        render :action => :add_friends
      end
    else
      flash[:error] = @flash_error
      render :action => :add_friends
    end
  end

  def create_friends
    flash[:registration] = flash[:registration]
    @family = current_family
    users = Array.new
    tokens = Array.new

    @emails = params[:emails].split(',')
    @emails = @emails.collect {|email| email.strip }
    @emails.delete("")
    @message = params[:message]

    @error = false

    if @emails.empty?
      @error = true
      @flash_notice = "You can't invite no one"
    end

    unless @error

      exist_users = User.where(['email IN (?)', @emails]).all

      unless @error
        @emails.each do |email|
          @user_exist = false

          exist_users.each do |exist_user|
            if exist_user.email == email
              @user = exist_user
              @user_exist = true
              break
            end
          end

          unless @user_exist
            @user = User.new(:email => email)
            @user.reset_password
            @user.reset_perishable_token
            @user.reset_single_access_token
          end

          unless @user.valid?
              @error = true
              break
          end

          user_relation = @user.relations.where(:family_id => @family.id).first

          if user_relation.nil?
            @user.relations.build :member_type => Relation::MEMBER_TYPE[:OTHER], :family_id => @family.id, :token => @user.perishable_token
          else
            user_relation.update_attribute(:token, @user.perishable_token)
          end

          tokens << @user.perishable_token
          @user.reset_perishable_token
          users << @user

        end
        
      end
      
    end

    if @error
      flash[:notice] = @flash_notice
      render :action => :add_friends
    else
      users.each do |user|
        user.save
        UserMailer.invite_user(user.relations.where(["family_id = ?",@family.id]).first, current_user, @message).deliver
      end
      flash[:notice] = 'Congrats you send emails to your friends :D!!'
      flash[:tokens] = tokens
      redirect_to relations_families_path
    end
    
  end

  def relations
    flash[:registration] = flash[:registration]
    @select_options = Array.new

    @select_options = (Relation::MEMBER_TYPE.select {|key, value| key != :PARENT}).collect {|key, value| [value.capitalize, value]}

    @relations = Relation.where(['token IN (?)', flash[:tokens]]).includes(:user).all
    flash[:tokens] = flash[:tokens]
    
  end

  def create_relations
    flash[:registration] = flash[:registration]
    @relations = Relation.where(['token IN (?)',flash[:tokens]]).all
    @relation_params = params[:relations]
    @relation_params.each do |relation_param|
      @relations.each do |relation|
        if relation.token == relation_param[1][:token]
          relation.display_name = relation_param[1][:display_name]
          relation.member_type = relation_param[1][:member_type]
          relation.save
        end
      end
    end
    redirect_to account_url
  end

  def family_relations_info
    @parents = my_family.relations.is_parent.accepted
    @rest = my_family.relations.is_not_parent.accepted
    
  end

end
