class FacebookController < ApplicationController
before_filter :require_user
  
  def index
    if params[:registration]
      @family_children = my_family.children
      params[:child_id] ||= @family_children.first.id
      @selected_child = (@family_children.select { |child| child.id.to_s == params[:child_id].to_s }).first

      respond_to do |format|
        format.html { render :partial => "registration/upload_photos/facebook/select_facebook_photos" }
      end
    else
      respond_to do |format|
        format.html { render :partial => "select_facebook_photos" }
      end
    end
    
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
