class MomentsController < ApplicationController

  before_filter :require_user
  before_filter :require_my_family
  before_filter :require_family_with_child
  skip_before_filter :clear_family_registration, :only => [:import_media]


  def index

  end

  def new    
    @moment = Moment.new
    @child = Child.find(params[:child_id]);    
  end

  def create
    if current_user.own_children.exists?(params[:cid])
      media = []
      media += Media.find(params[:uploaded_images_pids]) unless params[:uploaded_images_pids].blank?
      media += MediaFacebook.create_media_objects(params[:facebook_photos], params[:facebook_pids], current_user.id)  unless  params[:facebook_photos].blank?
      media += MediaFlickr.create_media_objects(params[:flickr_photos], params[:flickr_pids], current_user.id)  unless  params[:flickr_pids].blank?
      media += MediaYoutube.create_media_objects(params[:youtube_videos], current_user.id)  unless  params[:youtube_videos].blank?
      media += MediaVimeo.create_media_objects(params[:vimeo_videos], current_user.id)  unless  params[:vimeo_videos].blank?

      moment = Moment.new(params[:moment])
      moment.child_id = params[:cid]
      media.each do |m|
        moment.attachments.build({ :media => m})
      end    
      moment.save
      flash[:notice] = "Moment has been successfuly created."
      redirect_to child_profile_children_url
    else
      flash[:error] = "Can't create moments for children from someone else's family"
    end   
  end
  

  def change_provider
    
    render :partial => "facebook/select_facebook_photos" if params[:provider] == 'facebook'
    render :partial => "flickr/select_flickr_photos" if params[:provider] == "flickr"
    render :partial => "uploaded_images/select_uploaded_images" if params[:provider] == 'uploaded-images'
    render :partial => "youtube/select_youtube_videos" if params[:provider] == 'youtube'
    render :partial => "vimeo/multiselect_vimeo_videos" if params[:provider] == 'vimeo'    
  end

  def edit    
  end

  def destroy    
  end

  def import_media
    @family_children = my_family.children
    params[:child_id] ||= @family_children.first.id
    @selected_child = (@family_children.select { |child| child.id.to_s == params[:child_id].to_s }).first

    next_child = @family_children.at((@family_children.index { |child_item| child_item.id == @selected_child.id })+1)
    next_child.nil? ? @next_child_name = "Save & Finish" : @next_child_name = "Go to #{next_child.first_name.capitalize}"
  end

  def create_from_media
    
    media = []
    media += Media.find(params[:uploaded_images_pids]) unless params[:uploaded_images_pids].blank?
    media += MediaFacebook.create_media_objects(params[:facebook_photos], params[:facebook_pids], current_user.id)  unless  params[:facebook_photos].blank?
    media += MediaFlickr.create_media_objects(params[:flickr_photos], params[:flickr_pids], current_user.id)  unless  params[:flickr_pids].blank?
    media += MediaYoutube.create_media_objects(params[:youtube_videos], current_user.id)  unless  params[:youtube_videos].blank?
    media += MediaVimeo.create_media_objects(params[:vimeo_videos], current_user.id)  unless  params[:vimeo_videos].blank?
     

    moments = []

    child = Child.find(params[:child_id])
    media_ids = (child.moments.collect { |moment_item| moment_item.media.collect { |media_item| media_item.id } }).flatten
     
    media.each do |m|
      unless media_ids.include?(m.id)
        mom = Moment.new
        mom.media << m
        mom.child = child
        mom.save
        moments << mom
      end
    end

    @family_children = my_family.children
    @selected_child = @family_children.at((@family_children.index { |child_item| child_item.id.to_s == params[:child_id].to_s })+1)
    if @selected_child.nil?
      redirect_to child_profile_children_path
    else

      next_child = @family_children.at((@family_children.index { |child_item| child_item.id == @selected_child.id })+1)
      next_child.nil? ? @next_child_name = "Save & Finish" : @next_child_name = "Go to #{next_child.first_name.capitalize}"
      
      render :action => :import_media
    end
     
  end




end
