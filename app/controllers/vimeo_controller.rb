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
    @error = "First select file to upload" if params[:file].blank?

    unless @error
      begin

        service = current_user.get_vimeo_service
        upload = Vimeo::Advanced::Upload.new(Yetting.vimeo["key"], Yetting.vimeo["secret"],:token => service.token, :secret => service.secret);
        upload.upload(params[:file].tempfile);
        
      rescue StandardError => e
          @error = e.message
          render :new, :layout => false
      else
        @container = 'vimeo-ajax-container'
        @ajax_link = vimeo_index_url
        render :partial => "shared/upload_video"
      end
      
    else
      render :new, :layout => false
    end
    
  end

end
