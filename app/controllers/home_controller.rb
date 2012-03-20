class HomeController < ApplicationController

  layout 'empty', :only => [:index]
  before_filter :require_user, :only => [:socials]
  before_filter :require_confirmation => [:socials]

  def index
  end

  def interior
    
  end

  def socials
  end

  def socials_create
    media =  MediaFacebook.create_image_objects(params[:facebook_photos].to_a, params[:facebook_pids].to_a)
     render :xml  => media

  end

end
