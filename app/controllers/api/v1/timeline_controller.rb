class Api::V1::TimelineController < ApplicationController
  
  layout false

  before_filter :require_user
  before_filter :require_child
  before_filter :require_seen_behaviours, :only => [:show]

  def index
    @children = current_user.children    
    @selected_child = @children.find_by_id(current_child.id)
    
    @relatives = @selected_child.users
    @timeline_entries = @selected_child.timeline_entries.includes(:comments, :media, :item).order("created_at DESC")

    max_by_cat = current_child.max_seen_by_category
    @child_has_str = current_child.replace_forms(max_by_cat[0].title_past) if max_by_cat[0]
    @child_has_weak = current_child.replace_forms(max_by_cat[-1].title_past) if max_by_cat[-1]


    @timeline_visited = current_user.done_action?('timeline_visited')
    current_user.do_action!('timeline_visited') unless @timeline_visited


    respond_to do |format|
      format.json { render :json => @timeline_entries }
      format.html
    end
  end

  def edit
    if current_child.user_is_admin?(current_user)
      @entry = current_child.timeline_entries.find(params[:id])    
    else
      render :text => 'No permission'
    end
  end
  def update_entry
    if current_child.user_is_admin?(current_user)
      @entry = current_child.timeline_entries.find(params[:id])
      @entry.update_entry(params[:details], params[:media_id])
    end
    redirect_to api_v1_timeline_path
  end    


  def add_entry    

    # entry_type is "play", "watch", "reflect", "likes", "dislikes" 
    # did_what is a description of the activity
    # details are the 'body' of a timeline post
    # category is not used atm
    # te_mid is not used atm
    
    @user = current_user
    if params[:image]
      @image = Media.new(:image => params[:image], :user => @user)
      if @image.save
        image_id = @image.id
      end
    else
      image_id = nil
    end
 
    te = TimelineEntry.build_entry(params[:entry_type], 
                                   params[:did_what],
                                   current_child,
                                   current_user,
                                   params[:details],
                                   params[:category],
                                   image_id,
                                   current_user.id,
                                   params[:te_mid]
                                 )
    te.save
    
    if params[:bid].present? 
      b = Behaviour.find_by_id(params[:bid])
      current_child.seen_behaviours.find_or_create_by_behaviour_id(b.id, :user => current_user) if b
    end
 
    respond_to do |format|
      format.json { render :json => { :success => true } } 
    end
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
