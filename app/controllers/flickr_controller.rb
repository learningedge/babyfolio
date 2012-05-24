class FlickrController < ApplicationController

  before_filter :require_user

  def flickr_ajax
    if params[:registration]
      @family_children = my_family.children
      params[:child_id] ||= @family_children.first.id
      @selected_child = (@family_children.select { |child| child.id.to_s == params[:child_id].to_s }).first

      respond_to do |format|
        format.html { render :partial => 'registration/upload_photos/flickr/select_flickr_photos', :locals => { :options => { :sets => true }} }
      end
    else
      respond_to do |format|
        format.html { render :partial => 'select_flickr_photos', :locals => { :options => { :sets => true }} }
      end
    end
    
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
