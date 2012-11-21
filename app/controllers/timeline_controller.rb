class TimelineController < ApplicationController

  layout "child"
  before_filter :require_user
  before_filter :require_child


  def show
    @children = current_user.children    
    @selected_child = @children.find_by_id(params[:child_id]) || @children.find_by_id(current_child.id)
    set_current_child @selected_child.id  unless params[:child_id].blank?

    @relatives = @selected_child.users
    @timeline_entries = @selected_child.timeline_entries.includes(:comments, :media).order("created_at DESC")
  end


  def add_entry
    te = TimelineEntry.new({ :entry_type => params[:entry_type], :child_id => current_child.id, :description => params[:details], :category => params[:category]})

    med = Media.find_by_id(params[:media_id])
    te.media << med if med
    who = User.find_by_id(params[:who]).get_user_name if params[:who]

    case te.entry_type
      when "play"
        title = "#{current_child.first_name} and #{who} #{params[:did_what]}"
      when "watch"
        title = "#{current_child.first_name} #{params[:did_what]} for #{who}"
      when "reflect"
        title = "#{who} has a question about #{current_child.first_name}"
      when "likes"
        title = "#{current_child.first_name} likes #{params[:likes]}"
      when "dislikes"
        title = "#{current_child.first_name} dislikes #{params[:dislikes]}"
      else
    end

    te.title = title
    te.save
    
    redirect_to show_timeline_path
  end

  def add_comment
    te = TimelineEntry.find_by_id(params[:te_id])
    te.comments.build({:text => params[:text], :author => current_user})
    te.save
    redirect_to show_timeline_path
  end


end
