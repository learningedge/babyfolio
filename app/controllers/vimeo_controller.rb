class VimeoController < ApplicationController

  before_filter :require_user

  def index 
    if(current_user.has_vimeo_account?) 
      @vids = current_user.get_vimeo_videos
    end
    render :partial => "multiselect_vimeo_videos"
 end

  def new
    render :new, :layout => false
  end

  def upload
    service = current_user.get_vimeo_service
    upload = Vimeo::Advanced::Upload.new(Yetting.vimeo["key"], Yetting.vimeo["secret"],:token => service.token, :secret => service.secret);
    upload.upload(params[:file].tempfile);

    @container = 'vimeo-ajax-container'
    @ajax_link = vimeo_index_url
    render :partial => "shared/upload_video"
  end

  def upload_video

  end


end
