class Registration::AddVideosController < ApplicationController

  before_filter :require_user
  before_filter :require_confirmation


  ##################
  # youube actions
  ##################

  def iframe_upload
    respond_to do |format|
      format.html { render 'registration/upload_videos/youtube/iframe_upload', :layout => false }
    end
  end

  def new_youtube
    @step_one = true
    @title = 'Upload video step 1'
    respond_to do |format|
      format.html { render 'registration/upload_videos/youtube/new_youtube', :layout => "none" }
    end
  end

  def upload_youtube
    @error = true if params[:youtube].nil? or params[:youtube][:title].blank?

    unless @error
      @step_two = true
      @video_upload = current_user.youtube_user.upload_token params[:youtube], registration_add_videos_upload_file_youtube_url
    else
      @step_one = true
    end
    
    respond_to do |format|
      format.html { render 'registration/upload_videos/youtube/new_youtube', :layout => "none" }
    end
  end

  def upload_file_youtube
    if params[:error].nil?
      respond_to do |format|
        @video = current_user.youtube_user.my_video(params[:id])
        format.html { render 'registration/upload_videos/youtube/upload_file_youtube', :layout => "none" }
      end
    end
  end



  ##################
  # vimeo actions
  ##################

  def new_vimeo
    respond_to do |format|
      format.html { render :partial => '/registration/upload_videos/vimeo/new_vimeo' }
    end
  end

  def upload_vimeo
    @error = "First select file to upload" if params[:file].blank?

    unless @error
      begin
        service = current_user.get_vimeo_service
        upload = Vimeo::Advanced::Upload.new(Yetting.vimeo["key"], Yetting.vimeo["secret"],:token => service.token, :secret => service.secret);
        vid_id = upload.upload(params[:file].tempfile);
        video = Vimeo::Advanced::Video.new(Yetting.vimeo["key"], Yetting.vimeo["secret"],:token => service.token, :secret => service.secret);
        if params[:title].present?
          video.set_title(vid_id["ticket"]["video_id"], params[:title])
        end
      rescue StandardError => e
          @error = e.message
          respond_to do |format|
            format.js { render '/registration/upload_videos/vimeo/new_vimeo' }
          end
      else
        respond_to do |format|
#          @vimeo_video = current_user.get_vimeo_videos.first
          @vimeo_video = video.get_info(vid_id["ticket"]["video_id"])["video"].first
          format.js { render '/registration/upload_videos/vimeo/uploaded_file' }
        end
      end

    else
      respond_to do |format|
        format.js { render '/registration/upload_videos/vimeo/new_vimeo' }
      end
    end
  end

  ##################
  #
  ##################

  def import_media

    if current_user.can_edit_child? params[:child_id]
      child = Child.find(params[:child_id])
      media = []
      titles = params[:media_titles]

      media += MediaYoutube.create_media_objects(params[:youtube_videos], current_user.id)  unless  params[:youtube_videos].blank?
      media += MediaVimeo.create_media_objects(params[:vimeo_videos], current_user.id)  unless  params[:vimeo_videos].blank?

      moments = []

      media_ids = (child.moments.collect { |moment_item| moment_item.media.collect { |media_item| media_item.id } }).flatten

      media.each_with_index do |m, idx|
        unless media_ids.include?(m.id)
          mom = Moment.new
          mom.media << m
          mom.child = child
          mom.title = titles[idx] unless titles.nil?
          params[:visiblity] ||= "public"
          mom.visibility = params[:visiblity]
          mom.save
          moments << mom
        end
      end
      respond_to do |format|
        format.text { render :text => 'Images Imported' }
      end      
    else
      respond_to do |format|
        format.text { render :text => "Sorry, you have no permission to add moments for this child"}
      end
    end

  end

end
