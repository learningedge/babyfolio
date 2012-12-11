class TimelineController < ApplicationController

  layout "child"
  before_filter :require_user
  before_filter :require_child
  before_filter :require_seen_behaviours, :only => [:show]

  def show_timeline
    @children = current_user.children    
    @selected_child = @children.find_by_id(params[:child_id]) || @children.find_by_id(current_child.id)
    set_current_child @selected_child.id  unless params[:child_id].blank?

    @relatives = @selected_child.users
    @timeline_entries = @selected_child.timeline_entries.includes(:comments, :media, :behaviour).order("created_at DESC")

    max_by_cat = current_child.max_seen_by_category
    @child_has_str = current_child.replace_forms(max_by_cat[0].milestone.title) if max_by_cat[0] && max_by_cat[0].milestone && max_by_cat[0].milestone.title.present?
    @child_has_weak = current_child.replace_forms(max_by_cat[-1].milestone.title) if max_by_cat[-1] && max_by_cat[-1].milestone && max_by_cat[-1].milestone.title.present?

    @timeline_visited = current_user.timeline_visited
    current_user.update_attribute(:timeline_visited, true)
  end

  def add_entry    
    te = TimelineEntry.build_entry(params[:entry_type], 
                                   params[:did_what],
                                   current_child,
                                   current_user,
                                   params[:details],
                                   params[:category],
                                   params[:media_id],
                                   params[:who]
                                 )
    te.save
    
    redirect_to show_timeline_path
  end  

  def add_from_popup
    te = TimelineEntry.build_entry(params[:entry_type],
                                   params[:content],
                                   current_child,
                                   current_user,
                                   params[:details],
                                   params[:category],
                                   params[:media_id],
                                   params[:who],
                                   params[:mid]
                                  )
    te.save

    respond_to do |format|
      format.html { render :text => '<h4 class="arvo success">Sucessfully submitted Timeline entry</h4>' }
    end
  end

  def reflect_to_timeline
    te = TimelineEntry.build_entry("watch",
                                   params[:did_what],
                                   current_child,
                                   current_user,
                                   params[:details],
                                   params[:te_category],
                                   params[:media_id],
                                   params[:who],
                                   params[:te_mid]
                                 )
    te.save

    respond_to do |format|
      format.html { render :text =>  "Success"  }
    end
  end

  def add_comment
    te = TimelineEntry.find_by_id(params[:te_id])
    te.comments.build({:text => params[:text], :author => current_user})
    te.save
    redirect_to show_timeline_path
  end


end
