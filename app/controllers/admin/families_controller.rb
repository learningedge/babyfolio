class Admin::FamiliesController < Admin::ApplicationController

  def index

    conditions = Array.new
    @title = "All Families"
    if params[:search_term]
      conditions << "(families.name like ?)"
      conditions << "%#{params[:search_term]}%"
      @title = "Search results for \"#{params[:search_term]}\""
    end

    params[:sort] ||= "families.name"

    if params[:see_all]
      @families = Family.paginate :all, :page => params[:page], :per_page => 1000000, :order => params[:sort], :conditions => conditions
    else
      @families = Family.paginate :page => params[:page], :order => params[:sort], :per_page => 10, :conditions => conditions
    end
  end

  def edit
    @family = Family.find(params[:id])

    users = @family.users
    @parents = @family.family_parents
    @rest_users = users - @parents
  end

  def update
    @family = Family.find(params[:id])

    if @family.update_attributes(params[:family])
      redirect_to admin_families_path, :notice => "#{@family.name}'s family was successfully updated"
    else
      response_to do |format|
        format.html { render :action => 'edit' }
      end
    end
    
  end

end
