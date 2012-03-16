class VimeoController < ApplicationController
  def index 
    if(current_user.has_vimeo_account?) 
      @vids = current_user.get_vimeo_videos
    end
    render :partial => "multiselect_vimeo_videos"
 end

  def new
  end

  def upload
    service = current_user.get_vimeo_service
    upload = Vimeo::Advanced::Upload.new(Yetting.vimeo["key"], Yetting.vimeo["secret"],:token => service.token, :secret => service.secret);
     upload.upload(params[:file].tempfile);
  end

  def vimeo_ajax
  end
end
