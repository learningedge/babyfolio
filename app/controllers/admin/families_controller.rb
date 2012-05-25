class Admin::FamiliesController < Admin::ApplicationController

  def index
    if params[:see_all]
      @families = Family.paginate :all, :page => params[:page], :per_page => 1000000, :order => params[:sort]
    else
      @families = Family.paginate :page => params[:page], :order => params[:sort], :per_page => 10
    end
  end

  def edit
    @family = Family.find(params[:id])
  end

  def update
    @family = Family.find(prams[:id])

    if @family.update_attributes(params[:family])
      redirect_to admin_families_path, :notice => "#{@family.name}'s family was successfully updated"
    else
      response_to do |format|
        format.html { render :action => 'edit' }
      end
    end
    
  end

end
