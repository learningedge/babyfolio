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
    @timeline_entries = @selected_child.timeline_entries.includes(:comments, :media, :behaviour).order("created_at DESC")

    max_by_cat = current_child.max_seen_by_category
    @child_has_str = current_child.replace_forms(max_by_cat[0].milestone.title) if max_by_cat[0] && max_by_cat[0].milestone && max_by_cat[0].milestone.title.present?
    @child_has_weak = current_child.replace_forms(max_by_cat[-1].milestone.title) if max_by_cat[-1] && max_by_cat[-1].milestone && max_by_cat[-1].milestone.title.present?

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
    redirect_to settings_invite_path
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
      format.html { render :text => "Success" }
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
