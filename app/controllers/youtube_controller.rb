class YoutubeController < ApplicationController

  before_filter :require_user
  before_filter :require_youtube_user, :only => [:new, :upload]

  def index

    @client = youtube_user

  end

  def new

    @step_one = true
    @title = 'Upload video step 1'

    render :new

  end

  def upload

    @step_two = true
    @title = 'Upload video step 2'

    @video_upload = youtube_user.upload_token params[:youtube], youtube_index_url

    render :new
  end

  def youtube_connect    
  end

  def youtube_ajax
    render :partial => 'multiselect_youtube_videos'
  end

private 

  def require_youtube_user
    
    redirect_to connect_youtube_index_path unless youtube_user

  end

end
