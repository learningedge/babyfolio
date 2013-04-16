class Admin::PagesController < Admin::ApplicationController
  def index
    conditions = Array.new

    if params[:search_term].present?
      conditions << "(pages.title like ?)"
      conditions << "%#{params[:search_term]}%"
      @title = "Search results for \"#{params[:search_term]}\""
    end    

    if params[:see_all]
      @pages = Page.paginate :all, :page => params[:page], :per_page => 1000000, :order => params[:sort], :conditions => conditions
    else
      @pages = Page.paginate :page => params[:page], :order => params[:sort], :per_page => 20, :conditions => conditions
    end
  end

  def edit
    @page = Page.find(params[:id])
  end
  
  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page])      
      redirect_to admin_pages_path, :notice => "Page successfully updated"
    else      
      render :action => 'edit'      
    end
  end
end
