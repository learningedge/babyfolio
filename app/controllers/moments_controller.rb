class MomentsController < ApplicationController

  before_filter :require_user
  before_filter :require_my_family
  before_filter :require_family_with_child

  def import_media
    
    @family_children = my_family.children
    @family_children_select = @family_children.collect { |child| [child.first_name.capitalize, child.id]}
    params[:child_id] ||= @family_children.first.id
    @selected_child = (@family_children.select { |child| child.id.to_s == params[:child_id].to_s }).first
    

  end

  def create_from_media
    
     media = []
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
   
#    render :xml => moments
    redirect_to :back
  end

  def index
  end

  def new
  end

  def edit
  end

  def create
  end

  def destroy
  end

  private 

end
