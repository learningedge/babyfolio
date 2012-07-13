class Registration::AddPhotosController < ApplicationController

  before_filter :require_user

  ##################
  # flickr actions
  ##################

  def flickr_photos

    unless params[:set_id].blank?
      photos = current_user.flickr_user.photosets.getPhotos(:photoset_id => params[:set_id]).photo
    else
      photos = current_user.flickr_user.photos.getNotInSet
    end
    respond_to do |format|
      format.html { render :partial => 'registration/upload_photos/flickr/photos_grid', :locals => { :photos => photos } }
    end    
  end

  def flickr_sets
    respond_to do |format|
      format.html { render :partial => 'registration/upload_photos/flickr/sets_grid' }
    end
  end

  ##################
  # facebook actions
  ##################

  def facebook_albums
    respond_to do |format|
      format.html { render :partial => "registration/upload_photos/facebook/albums" }
    end
  end

  def facebook_photos
    service = current_user.get_facebook_service
    @select = params[:select]
    @photos = FbGraph::Album.new(params[:album],:access_token => service.token).photos
    respond_to do |format|
      format.html { render :partial => 'registration/upload_photos/facebook/album_photos' }
    end
  end

  ##################
  # upload photos actions
  ##################

  def photo
    one_image = Media.find(params[:media_id])
    respond_to do |format|
      format.html { render :partial => 'registration/upload_photos/uploaded_images/uploaded_image', :locals => {:photo => one_image, :moment_id => params[:moment_id]} }
    end
    
  end

  def remove_moment
    moment = Moment.find(params[:id])
    moment.destroy();

    render :text => "removed";
  end

  def update_visibility
    s = ''
    Moment.find(params[:moments]).each do |m|
      m.visibility = params[:visibility]
      m.save
      s += m.id.to_s
    end

    render :text => s
  end

  def create_photo
    child_id = params[:child_id]
    visibility = params[:visibility] || 'public';

    if params[:qqfile].kind_of? String
      ext = '.' + params[:qqfile].split('.').last
      fname = params[:qqfile].split(ext).first
      tempfile = Tempfile.new([fname, ext])
      tempfile.binmode
      tempfile << request.body.read
      tempfile.rewind
    else
      tempfile = params[:qqfile].tempfile
    end

    media = MediaImage.create_media_object(tempfile, current_user.id)
    child = Child.find(child_id)

    mom = Moment.new
    mom.media << media
    mom.child = child
    mom.visibility = visibility
    mom.user = current_user
    mom.save

    log_description = Array.new
    log_description << "MOMENT ##{mom.id} CREATED IN REGISTRATION PROCESS:"
    log_description << "Title: #{mom.title}"
    Log.create_log current_user.id, log_description
    
    respond_to do |format|
      format.html { render :text => "{\"media_id\":\"#{media.id}\", \"moment_id\":\"#{mom.id}\"}" }
    end
  end

  ##################
  # global import media (images) action
  ##################

  def import_media

    if current_user.can_edit_child? params[:child_id]
      media = []
      titles = params[:media_titles]
      media += Media.find(params[:uploaded_images_pids]) unless params[:uploaded_images_pids].blank?
      media += MediaFacebook.create_media_objects(params[:facebook_photos], params[:facebook_pids], current_user.id)  unless  params[:facebook_photos].blank?
      media += MediaFlickr.create_media_objects(params[:flickr_photos], params[:flickr_pids], current_user.id)  unless  params[:flickr_pids].blank?  

      moments = []

      child = Child.find(params[:child_id])
      media_ids = (child.moments.collect { |moment_item| moment_item.media.collect { |media_item| media_item.id } }).flatten

      @media_index = 0;            
      media.each_with_index do |m, idx|
        @media_index += 1
        unless media_ids.include?(m.id)          
          mom = Moment.new
          mom.media << m
          mom.child = child
          mom.title = titles[idx] unless titles.nil?
          params[:visiblity] ||= "public"
          mom.visibility = params[:visiblity]
          mom.save

          log_description = Array.new
          log_description << "MOMENT ##{mom.id} CREATED IN REGISTRATION PROCESS:"
          log_description << "Title: #{mom.title}"          
          Log.create_log current_user.id, log_description

          moments << mom
        end
      end      
      if @media_index > 0
          @import_message = " images uploaded successfully."
      else
          @import_message = "First select images."
      end
      respond_to do |format|
        format.js { render '/registration/upload_photos/import_message' }
      end
    else
      respond_to do |format|
        format.js { render '/errors/permission' }
      end
    end
  end

end
