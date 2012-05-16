class VimeoController < ApplicationController

  before_filter :require_user

  def index 
    if(current_user.has_vimeo_account?) 
      @vids = current_user.get_vimeo_videos
    end
    if params[:registration]
      respond_to do |format|
        format.html { render :partial => "registration/upload_videos/vimeo/select_vimeo_videos" }
      end
    else
      respond_to do |format|
        format.html { render :partial => "multiselect_vimeo_videos" }
      end
    end
 end

  def new
    respond_to do |format|
      format.html { render :new, :layout => false }
    end
  end

  def upload
    @error = "First select file to upload" if params[:file].blank?
    
    unless @error
      begin
        service = current_user.get_vimeo_service
        upload = Vimeo::Advanced::Upload.new(Yetting.vimeo["key"], Yetting.vimeo["secret"],:token => service.token, :secret => service.secret);        
        vid_id = upload.upload(params[:file].tempfile);
        if params[:title].present?
          video = Vimeo::Advanced::Video.new(Yetting.vimeo["key"], Yetting.vimeo["secret"],:token => service.token, :secret => service.secret);        
          video.set_title(vid_id["ticket"]["video_id"], params[:title])        
        end
      rescue StandardError => e
          @error = e.message
          respond_to do |format|
            format.html { render :new, :layout => false }
          end
      else
        @container = 'vimeo-ajax-container'
        @ajax_link = vimeo_index_url
        respond_to do |format|
          format.html { render :partial => "shared/upload_video" }
        end        
      end
      
    else
      respond_to do |format|
        format.html { render :new, :layout => false }
      end
    end
  end

end
