class UploadedImagesController < ApplicationController

  def index

    @one_image = Media.find(params[:id])

    render :index, :layout => false
  end

  def update

    ext = '.' + params[:qqfile].split('.').last
    fname = params[:qqfile].split(ext).first

    tempfile = Tempfile.new([fname, ext])

    tempfile.binmode
    tempfile << request.body.read
    tempfile.rewind

    media = MediaImage.create_media_object(tempfile, current_user.id)

    render :text => "{\"media_id\":\"#{media.id}\"}"
    
  end

  
end
