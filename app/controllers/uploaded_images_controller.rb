class UploadedImagesController < ApplicationController

  def index

    @one_image = Media.find(params[:id])

    render :index, :layout => false
    
  end

  def update
    
    if params[:qqfile].kind_of? String
      ext = '.' + params[:qqfile].split('.').last
      fname = params[:qqfile].split(ext).first
      tempfile = Tempfile.new([fname, ext])
      tempfile.binmode
      tempfile << request.body.read
      tempfile.rewind
    else
      tempfile = params[:qqfile].tempfile
    end

    media = MediaImage.create_media_object(tempfile, current_user.id)

    render :text => "{\"media_id\":\"#{media.id}\"}"    
  end

  
end
