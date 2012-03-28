class ChildrenController < ApplicationController

  before_filter :require_user
  #  before_filter :require_confirmation
  before_filter :require_family
  before_filter :require_family_with_child

  def show

    @user = current_user
    @families = @user.families
    @selected_family = current_family    
    @children = @selected_family.children
    @selected_child ||= params[:child_id].present? ? (@children.select { |c| c.id == params[:child_id].to_i }.first || @children.first) : @children.first
    
  end

  def edit
    @child = Child.find(params[:id])    
  end

  def update

    if !params[:flickr_photos].blank?
      media_element = MediaFlickr.create_media_objects(params[:flickr_photos].first, params[:flickr_pids].first, current_user.id)
    elsif !params[:facebook_photos].blank?
      media_element = MediaFacebook.create_media_objects(params[:facebook_photos].first, params[:facebook_pids].first, current_user.id)
    elsif !params[:uploaded_images_pids].blank?
      media_element = Media.find(params[:uploaded_images_pids].first)
    end

    @child = Child.find(params[:id])
    @child.media = media_element
    @child.save

    redirect_to child_profile_children_url
  end  
  
end
