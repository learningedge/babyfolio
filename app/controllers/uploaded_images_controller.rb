class UploadedImagesController < ApplicationController

  def index
    images = Media.where(:user_id => current_user.id, :type => 'MediaImage')

    render :partial => 'uploaded_images/uploaded_images', :locals => { :images => images}
  end

  def update

    ext = '.' + params[:qqfile].split('.').last
    fname = params[:qqfile].split(ext).first

    tempfile = Tempfile.new([fname, ext])

    tempfile.binmode
    tempfile << request.body.read
    tempfile.rewind

    MediaImage.create_media_object(tempfile, current_user.id)

    render :text => "image uploaded"
    
  end

  
end
