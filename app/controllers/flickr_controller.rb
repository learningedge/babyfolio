class FlickrController < ApplicationController

  before_filter :require_user

  def index

#     render :text => current_user.flickr_user.photos.getNotInSet.inspect
#     render :text => current_user.flickr_user.photosets.getList.inspect
    
  end

  def flickr_ajax

    render :partial => 'select_flickr_photos', :locals => { :options => { :sets => true }}

  end

  def flickr_sets
    render :partial => 'sets_grid'
  end

  def flickr_photos

    if params[:set_id] 
      photos = current_user.flickr_user.photosets.getPhotos(:photoset_id => params[:set_id]).photo
    else
      photos = current_user.flickr_user.photos.getNotInSet
    end

    render :partial => 'photos_grid', :locals => { :photos => photos }
  end

  

end
