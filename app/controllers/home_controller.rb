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

  def upload_image

  ext = '.' + params[:qqfile].split('.').last
  fname = params[:qqfile].split(ext).first

  tempfile = Tempfile.new([fname, ext])

  tempfile.binmode
  tempfile << request.body.read
  tempfile.rewind

  media = MediaImage.create_media_object(tempfile, current_user.id)


 render :text => media.image.url(:thumbnail)
    # Save to temp file
#    File.open(tmp_file, 'wb') do |f|
#      if ajax_upload
#        f.write  request.body.read
#      else
#        f.write params[:qqfile].read
#      end
#    end
    # Now you can do your own stuff

  end

  def socials_create
    media =  MediaFacebook.create_image_objects(params[:facebook_photos].to_a, params[:facebook_pids].to_a)
    render :xml  => media

  end

end
