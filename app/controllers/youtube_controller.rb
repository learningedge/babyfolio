class YoutubeController < ApplicationController

  before_filter :require_user
  before_filter :require_confirmation

  def new
    @step_one = true
    @title = 'Upload video step 1'
    respond_to do |format|
      format.html { render :new, :layout => false }
    end
  end

  def upload
    @error = true if params[:youtube][:title].blank?

    unless @error
      @step_two = true
      @video_upload = current_user.youtube_user.upload_token params[:youtube], upload_video_new_youtube_url      
    else
      @step_one = true
    end
    
    respond_to do |format|
      format.html { render :new, :layout => false }
    end
    
  end

  def upload_video
    @container = 'youtube-ajax-container'
    @ajax_link = ajax_youtube_index_url
    
    respond_to do |format|
      format.html { render :partial => "shared/upload_video" }
    end
    
  end

  def youtube_ajax

    if params[:registration]
      respond_to do |format|
        format.html { render :partial => 'registration/upload_videos/youtube/select_youtube_videos' }
      end
    else
      respond_to do |format|
        format.html { render :partial => 'select_youtube_videos' }
      end
    end
    
  end
  
end

