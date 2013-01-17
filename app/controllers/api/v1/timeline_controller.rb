class Api::V1::TimelineController < ApplicationController
  
  layout false

  before_filter :require_user
  before_filter :require_child
  before_filter :require_seen_behaviours, :only => [:show]
 
  def index
    @children = current_user.children    
    @selected_child = @children.find_by_id(current_child.id)
    
    @relatives = @selected_child.users
    @timeline_entries = @selected_child.timeline_entries.includes(:comments, :media, :behaviour).order("created_at DESC")

    max_by_cat = current_child.max_seen_by_category
    @child_has_str = current_child.replace_forms(max_by_cat[0].milestone.title) if max_by_cat[0] && max_by_cat[0].milestone && max_by_cat[0].milestone.title.present?
    @child_has_weak = current_child.replace_forms(max_by_cat[-1].milestone.title) if max_by_cat[-1] && max_by_cat[-1].milestone && max_by_cat[-1].milestone.title.present?

    @timeline_visited = current_user.timeline_visited
    current_user.update_attribute(:timeline_visited, true)

    respond_to do |format|
      format.json { render :json => @timeline_entries }
      format.html
    end
  end

  def create
  end

  def add_comment
    te = TimelineEntry.find_by_id(params[:te_id])

    if te.is_auto
      ccount = te.comments.count
      te.description = "" if ccount == 0
    end
    
    te.comments.build({:text => params[:text], :author => current_user})
    te.save
    redirect_to api_v1_timeline_path
  end
end
