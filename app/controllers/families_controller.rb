class FamiliesController < ApplicationController
  def new
    @family = Family.new
    10.times {
      @family.children.build
    }
    @family.relations.build :user => User.new(:email => current_user.email), :member_type => 'parent', :display_name => current_user.first_name
    @family.relations.build :user => User.new , :member_type => 'parent'
    
  end

  def create
    @family = Family.new(params['family'])    
    @family.relations.first.user = current_user    
    @family.relations.first.user.reset_perishable_token
    @family.relations.first.user.reset_single_access_token
    if @family.relations.fetch(1).user.email.empty?
      @family.relations.delete_at(1)
    else
      @family.relations.fetch(1).user.reset_password
      @family.relations.fetch(1).user.reset_perishable_token
      @family.relations.fetch(1).user.reset_single_access_token
    end   
    
    respond_to do |format|
      if @family.save
        format.html { redirect_to :controller => 'home', :action => 'index' , :notice => 'Family has been successfully created.' }
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

    @family = current_user.families.parent

    puts @family

    redirect_to add_friends_families_url
  end

end
