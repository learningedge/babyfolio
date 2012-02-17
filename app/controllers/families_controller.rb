class FamiliesController < ApplicationController
  def new
    @family = Family.new
    10.times {
      @family.children.build
    }
    @family.relations.build :user => User.new(current_user.attributes), :member_type => 'parent'
    @family.relations.build :user => User.new , :member_type => 'parent'    
  end

  def create
    @family = Family.new(params['family']);
    current_user.attributes.merge!(@family.relations.first.user.attributes)
    @family.relations.first.user = current_user
    #    @family.relations.first.user.id = current_user.id
    

    respond_to do |format|
      if @family.save
        format.html { redirect_to :controller => 'home', :action => 'index' , :notice => 'Product was successfully created.' }
        format.xml  { render :xml => @family, :status => :created, :location => @family }
      else
        @family.relations.first.user = User.new(current_user.attributes)
        while @family.children.length < 10 do
          @family.children << Child.new
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
      end
    end
  end

end
