class FacebookController < ApplicationController
before_filter :require_user
  
  def index
    render :partial => "select_facebook_photos"
  end

  def albums
    render :partial => "albums"
  end

  def album_photos
    service = current_user.get_facebook_service
    @select = params[:select]
    @photos = FbGraph::Album.new(params[:album],:access_token => service.token).photos
    render :partial => 'album_photos'
  end

end
