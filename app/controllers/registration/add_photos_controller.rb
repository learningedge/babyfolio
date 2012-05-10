class Registration::AddPhotosController < ApplicationController

  ##################
  # flickr actions
  ##################

  def flickr_photos

    unless params[:set_id].blank?
      photos = current_user.flickr_user.photosets.getPhotos(:photoset_id => params[:set_id]).photo
    else
      photos = current_user.flickr_user.photos.getNotInSet
    end
    
    render :partial => 'registration/upload_photos/flickr/photos_grid', :locals => { :photos => photos }
    
  end

  def flickr_sets
    render :partial => 'registration/upload_photos/flickr/sets_grid'
  end

  ##################
  # facebook actions
  ##################

  def facebook_albums
    render :partial => "registration/upload_photos/facebook/albums"
  end

  def facebook_photos
    service = current_user.get_facebook_service
    @select = params[:select]
    @photos = FbGraph::Album.new(params[:album],:access_token => service.token).photos
    render :partial => 'registration/upload_photos/facebook/album_photos'
  end

  ##################
  # upload photos actions
  ##################

  def import_media
  media = []
    titles = params[:media_titles]
    media += Media.find(params[:uploaded_images_pids]) unless params[:uploaded_images_pids].blank?
    media += MediaFacebook.create_media_objects(params[:facebook_photos], params[:facebook_pids], current_user.id)  unless  params[:facebook_photos].blank?
    media += MediaFlickr.create_media_objects(params[:flickr_photos], params[:flickr_pids], current_user.id)  unless  params[:flickr_pids].blank?
    media += MediaYoutube.create_media_objects(params[:youtube_videos], current_user.id)  unless  params[:youtube_videos].blank?
    media += MediaVimeo.create_media_objects(params[:vimeo_videos], current_user.id)  unless  params[:vimeo_videos].blank?

    moments = []

    child = Child.find(params[:child_id])
    media_ids = (child.moments.collect { |moment_item| moment_item.media.collect { |media_item| media_item.id } }).flatten

    media.each_with_index do |m, idx|
      unless media_ids.include?(m.id)
        mom = Moment.new
        mom.media << m
        mom.child = child
        mom.title = titles[idx]
        mom.save
        moments << mom
      end
    end
    respond_to do |format|
      format.text { render :text => 'Images Imported' }
    end
  end

end
