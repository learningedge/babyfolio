class FacebookController < ApplicationController
before_filter :require_facebook_account
before_filter :require_user
  
  def index 
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

  def require_facebook_account
    render :text => 'You dont have facebook accout connected.<a href="/auth/facebook/">Click here</a> to connect one.' unless current_user.has_facebook_account?
  end

end
