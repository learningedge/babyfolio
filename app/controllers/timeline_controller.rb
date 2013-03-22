class TimelineController < ApplicationController

  layout "child"
  before_filter :require_user
  before_filter :require_child
  before_filter :require_seen_behaviours, :only => [:show_timeline]  

  def visit_timeline
    set_current_child params[:child_id]
    redirect_to show_timeline_path
  end

  def show_timeline
    @children = current_user.children    
    @selected_child = @children.find_by_id(current_child.id)
    
    @relatives = @selected_child.users
    @timeline_entries = @selected_child.timeline_entries.includes(:comments, :media, :item).order("created_at DESC")

    max_by_cat = current_child.max_seen_by_category
    @child_has_str = current_child.replace_forms(max_by_cat[0].title_past) if max_by_cat[0]
    @child_has_weak = current_child.replace_forms(max_by_cat[-1].title_past) if max_by_cat[-1]

    @timeline_visited = current_user.done_action?('timeline_visited')
    current_user.do_action!('timeline_visited') unless @timeline_visited

    @show_reminder = false
    if current_user.login_count >= 3 && !session[:remind_timeline]
      unless current_user.done_action?('timeline_dont_remind')
        @show_reminder = true
        @show_dont_btn = true if current_user.done_action?('timeline_remind')
      end
    end   
  end

  def invite_redirect
    current_user.do_action!('timeline_dont_remind')
    session[:remind_timeline] = true
    redirect_to settings_invite_path(:family_id => current_child.family.id)
  end

  def dont_remind
    session[:remind_timeline] = true
    current_user.do_action!('timeline_dont_remind')
    respond_to do |format|
      format.html { render :nothing => true }
    end    
  end

  def remind_later
    session[:remind_timeline] = true
    current_user.do_action!('timeline_remind')
    respond_to do |format|
      format.html { render :nothing => true }
    end    
  end

  def add_entry    
    te = TimelineEntry.build_entry(params[:entry_type], 
                                   params[:did_what],
                                   current_child,
                                   current_user,
                                   params[:details],
                                   params[:category],
                                   params[:media_id],
                                   params[:who],
                                   params[:te_mid]
                                 )
    te.save
    
    redirect_to show_timeline_path
  end    

  def add_from_popup
    b = Behaviour.find_by_id(params[:bid]) if params[:bid].present?
    a = Activity.find_by_id(params[:aid]) if params[:aid].present?
    te = TimelineEntry.build_entry(params[:entry_type],
                                   params[:content],
                                   current_child,
                                   current_user,
                                   params[:details],
                                   params[:category],
                                   params[:media_id],
                                   params[:who],
                                   a || b
                                  )
    te.save
    if (params[:submit_type] == "timeline")
      respond_to do |format|      
        format.html { render :text => '<h4 class="arvo success">Sucessfully submitted Timeline entry</h4>' }
      end
    else
      current_child.seen_behaviours.find_or_create_by_behaviour_id(b.id, :user => current_user)
      respond_to do |format|
        format.html { render :text => 'success' }
      end
    end
  end

  def reflect_to_timeline
    b = Behaviour.find_by_id(params[:bid])
    te = TimelineEntry.build_entry("watch",
                                   params[:did_what],
                                   current_child,
                                   current_user,
                                   params[:details],
                                   b.category,
                                   params[:media_id],
                                   params[:who],
                                   b
                                 )
    te.save

    respond_to do |format|
      format.html { render :text => "Success" }
    end
  end

  def update_entry
    if current_child.user_is_admin?(current_user)
      @entry = current_child.timeline_entries.find(params[:id])
      @entry.update_entry(params[:details], params[:media_id])
    end
    redirect_to show_timeline_path
  end    

  def get_timeline_entry_edit_popup
    if current_child.user_is_admin?(current_user)
      @entry = current_child.timeline_entries.find(params[:id])    
    
      render :partial => 'children/timeline_edit_popup'
    else
      render :text => 'No permission'
    end
  end

  def delete_timeline_entry
    if current_child.user_is_admin?(current_user)
      @entry = current_child.timeline_entries.find(params[:id])
      @entry.destroy
      
      render :text => 'Success'
    else
      render :text => 'No permission'
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

    current_child.admins.each do |admin|
      UserMailer.timeline_comment(current_child, current_user, admin).deliver unless admin.id == current_user.id
    end
    
    redirect_to show_timeline_path
  end

  def error
    User.testing_user_function
  end

end
