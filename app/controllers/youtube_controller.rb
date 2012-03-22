class YoutubeController < ApplicationController

  before_filter :require_user
  before_filter :require_confirmation

  def new

    @step_one = true
    @title = 'Upload video step 1'

    render :new, :layout => false

  end

  def upload

    @step_two = true
    @title = 'Upload video step 2'

    @video_upload = current_user.youtube_user.upload_token params[:youtube], upload_video_new_youtube_url

    render :new, :layout => false

  end

  def upload_video
    @container = 'youtube-ajax-container'
    @ajax_link = ajax_youtube_index_url
    render :partial => "shared/upload_video"
  end

  def youtube_ajax

    render :partial => 'select_youtube_videos'

  end


end
