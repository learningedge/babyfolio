class Admin::BehavioursController < Admin::ApplicationController

  def index
    conditions = Array.new

    if params[:search_term].present?


      conditions << "(" +
        "behaviours.title_present like ?" +
        " OR behaviours.title_past like ?" +
        " OR behaviours.description_short like ?" +
        " OR behaviours.description_long like ?" +
        " OR behaviours.example1 like ?" +
        " OR behaviours.example2 like ?" + 
        " OR behaviours.example3 like ?" + 
        ")"

      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"

      @title = "Search results for \"#{params[:search_term]}\""
    end    

    sort_value = params[:sort] ? params[:sort] : "behaviours.age_from ASC, behaviours.age_to ASC"

    if params[:see_all]
      @behaviours = Behaviour.paginate :all, :page => params[:page], :per_page => 1000000, :order => sort_value, :conditions => conditions
    else
      @behaviours = Behaviour.paginate :page => params[:page], :order => sort_value, :per_page => 100, :conditions => conditions
    end    
  end

  def edit
    @behaviour = Behaviour.find_by_id(params[:id]);    
  end

  def update
    @behaviours = Behaviour.find(params[:id])

    if @behaviours.update_attributes(params[:behaviour])      
      redirect_to admin_behaviours_path, :notice => "Behavoiur successfully updated"
    else      
      render :action => 'edit'      
    end
  end
end
