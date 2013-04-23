class Admin::ActivitiesController < Admin::ApplicationController

  def index
    conditions = Array.new

    if params[:search_term].present?


      conditions << "(" +
        "activities.title like ?" +
        " OR activities.description_short like ?" +
        " OR activities.description_long like ?" +
        " OR activities.variation1 like ?" +
        " OR activities.variation2 like ?" +
        " OR activities.variation3 like ?" +
        ")"

      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"
      conditions << "%#{params[:search_term]}%"

      @title = "Search results for \"#{params[:search_term]}\""
    end    

    sort_value = params[:sort] ? params[:sort] : "activities.age_from asc, activities.age_to";

    if params[:see_all]
      @activities = Activity.paginate :all, :page => params[:page], :per_page => 1000000, :order => sort_value, :conditions => conditions
    else
      @activities = Activity.paginate :page => params[:page], :order => sort_value, :per_page => 100, :conditions => conditions
    end    
  end

  def edit
    @activity = Activity.find_by_id(params[:id]);    
  end

  def update
    @activity = Activity.find(params[:id])

    if @activity.update_attributes(params[:activity])      
      redirect_to admin_activities_path, :notice => "Activity successfully updated"
    else      
      render :action => 'edit'      
    end
  end
end
