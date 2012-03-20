class MomentsController < ApplicationController

  def import_media 
  end

  def create_from_media
     media = []
     media += MediaFacebook.create_media_objects(params[:facebook_photos], params[:facebook_pids], current_user.id)  unless  params[:facebook_photos].blank?
     media += MediaFlickr.create_media_objects(params[:flickr_photos], params[:flickr_pids], current_user.id)  unless  params[:flickr_pids].blank?
     media += MediaYoutube.create_media_objects(params[:youtube_videos], current_user.id)  unless  params[:youtube_videos].blank?
     media += MediaVimeo.create_media_objects(params[:vimeo_videos], current_user.id)  unless  params[:vimeo_videos].blank?

     moments = []
     media.each do |m|
      mom = Moment.new
      mom.media << m
      mom.save
      moments << mom
     end
   
#    render :xml => moments
    redirect_to child_profile_children_path
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
