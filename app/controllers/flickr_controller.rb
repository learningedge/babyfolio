class FlickrController < ApplicationController

  before_filter :require_user
  helper_method :flickr_images

  def index
    
  end

  def flickr_connect
    
    @service = Service.find_or_create_by_user_id_and_provider(current_user.id,'flickr')
    @service.update_attribute(:uid, params[:flickr_id])
    @service.save
    
    render :partial => 'select_flickr_photos'

  end

end
